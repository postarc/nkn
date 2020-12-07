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
if [ -f stackscripts.id ]; then
	STACK_ID=$(cat stackscripts.id)
else
    JSON_DATA="{ \"label\" : \"$SERVER_NAME\","
    JSON_DATA+='"description" : "NKN node Installing","images" : [ "linode/ubuntu16.04lts","linode/ubuntu18.04","linode/ubuntu19.10","linode/ubuntu20.04" ],'
    JSON_DATA+='"is_public" : false,"rev_note" : "Set up NKN node","script" : "#!/bin/bash\ngit clone https://github.com/postarc/nkn.git\nsudo bash nkn/installmc.sh\nsudo systemctl restart nkn.service\n" }'
    #echo $JSON_DATA | jq '.'
    curl -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" \
       -X POST -d "${JSON_DATA}"  https://api.linode.com/v4/linode/stackscripts | jq '.id | tonumber' >> stackscripts.id
fi

COUNTER=0
while [ $COUNTER -lt $NODE_COUNT ]; do
    SERVER_LABEL=$SERVER_NAME$(printf "%0*d\n" 3 $(($STARTING_COUNTER+$COUNTER)))
    JSON_DATA="{ \"backups_enabled\": false, \"swap_size\": 1025, \"image\": \"linode/ubuntu18.04\", \"root_pass\": \"$PASSWORD\", \"stackscript_id\": $STACK_ID, \
          \"booted\": true, \"label\": \"$SERVER_LABEL\", \"type\": \"g6-nanode-1\", \"region\": \"$SERVER_REGION\", \"group\": \"Linode-Group\" }"

    #echo $JSON_DATA | jq '.'
    echo -e "${CYAN}Instances $SERVER_LABEL creating...${NC}"
    curl -H "Content-Type: application/json"  -H "Authorization: Bearer $TOKEN" -X POST -d "${JSON_DATA}" \
        https://api.linode.com/v4/linode/instances | jq -c '.data[].ipv4' | tr -d \"[] >> serverip.list
	(( COUNTER++ ))
done

