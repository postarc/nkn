#!/bin/bash

#color
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

SERVER_NAME="nkn-node"
STARTING_COUNTER=1
LOG_FILE='linstall.log'
#SERVER_IP_FILE='serverip.list'


echo -e -n "${YELLOW}Personal Access Token: ${NC}"
read TOKEN
if [ -z $TOKEN ]; then exit ; fi

echo -e -n "${YELLOW}Number of nodes to run [default: 1]: ${NC}"
read NODE_COUNT
if [ -z $NODE_COUNT ]; then NODE_COUNT=1; fi
echo -e -n "${YELLOW}Server region [default: us-east]: ${NC}"
read SERVER_REGION
if [ -z $SERVER_REGION ]; then SERVER_REGION="us-east" ; fi
echo -e -n "${YELLOW}Username [default: nknuser]: ${NC}"
read USERNAME
if [ -z $USERNAME ]; then USERNAME="nknuser" ; fi
echo -e -n "${YELLOW}Password [default: P@ssNkn987]: ${NC}"
read PASSWORD
if [ -z $PASSWORD ]; then PASSWORD="P@ssNkn987" ; fi

echo -e "${CYAN}Preparing...${NC}"
sudo apt update
sudo apt -y install curl jq

echo -e "${CYAN}Stackscripts creating...${NC}"
JSON_DATA="{ \"label\" : \"$SERVER_NAME\","
JSON_DATA+='"description" : "NKN node Installing","images" : [ "linode/ubuntu16.04lts","linode/ubuntu18.04","linode/ubuntu19.10","linode/ubuntu20.04" ],'
JSON_DATA+='"is_public" : false,"rev_note" : "Set up NKN node","script" : "#!/bin/bash\ngit clone https://github.com/postarc/nkn.git\nsudo bash nkn/installmc.sh\nsudo systemctl restart nkn.service\n" }'
echo -e "${MAG}Script Request:${NC}\n" > $LOG_FILE
echo $JSON_DATA | jq '.' >> $LOG_FILE
STACK_ID=$(curl -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" \
  -X POST -d "${JSON_DATA}"  https://api.linode.com/v4/linode/stackscripts | jq '.id | tonumber')
echo -e "${BLUE}Script ID:$STACK_ID${NC}" >> $LOG_FILE
if [[ -z $STACK_ID ]] || [[ $STACK_ID == "null" ]]; then echo -e "${RED}Stack script creating error, result:$STACK_ID${NC}"; exit; fi

COUNTER=0
while [ $COUNTER -lt $NODE_COUNT ]; do
    SERVER_LABEL=$SERVER_NAME$(printf "%0*d\n" 3 $(($STARTING_COUNTER+$COUNTER)))
    echo -e "${CYAN}Instance $SERVER_LABEL creating...${NC}"
    JSON_DATA="{ \"backups_enabled\": false, \"swap_size\": 1025, \"image\": \"linode/ubuntu18.04\", \"root_pass\": \"$PASSWORD\", \"stackscript_id\": $STACK_ID, \
          \"booted\": true, \"label\": \"$SERVER_LABEL\", \"type\": \"g6-nanode-1\", \"region\": \"$SERVER_REGION\", \"group\": \"Linode-Group\" }"
    echo -e "${MAG}Server Request:\n${NC}" >> $LOG_FILE
    echo $JSON_DATA | jq '.' >> $LOG_FILE
    SERVER_IP=$(curl -H "Content-Type: application/json"  -H "Authorization: Bearer $TOKEN" -X POST -d "${JSON_DATA}" \
        https://api.linode.com/v4/linode/instances)
    #echo -e -n "${BLUE}Server IP:${NC}"
    #echo $SERVER_IP | jq '.data[].ipv4' | tr -d \"[]
    echo $SERVER_IP | jq '.' >> $LOG_FILE
    if [[ -z $SERVER_IP ]] || [[ $SERVER_IP == "null" ]]; then echo  -e "${RED}Server creating error, result:$STACK_ID${NC}:"; exit
    #else echo $SERVER_IP >> $SERVER_IP_FILE
    fi
    (( COUNTER++ ))
done

if [[ $STACK_ID =~ ^[0-9]+$ ]] ; then
    echo -e "${CYAN}Stack script removing...${NC}"
    echo -e "${MAG}Script Remove Request:\n${NC}" >> $LOG_FILE
    curl -H "Authorization: Bearer $TOKEN" -X DELETE https://api.linode.com/v4/linode/stackscripts/$STACK_ID | jq '.' >> $LOG_FILE
fi
echo
echo -e "${CYAN}Servers IP list:${NC}"
curl -H "Authorization: Bearer $TOKEN" https://api.linode.com/v4/linode/instances | jq -c '.data[].ipv4' | tr -d \"[]
echo
echo -e "${GREEN}All done!!! Servers created: $COUNTER ${NC}"
