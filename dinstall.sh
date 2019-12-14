#!/bin/bash

GITPATH="https://github.com/nknorg/nkn.git"
RELEASES_PATH="https://github.com/nknorg/nkn/releases/download"
DIR_NAME="linux-amd64"
FCONFIG="config.json"
FWALLET="wallet.json"
START_SCRIPT="nknstart.sh"
IP_LIST="ip.list"
DIR_LIST="dir.list"
IDTXFEE=1
NODEDIR="nkn"
INDEX=1
IP_ADDRESS=""
ADDRESS=""
HOMEFOLDER="${PWD}/nknscripts"
if [ -f dinstall.sh ]; then cd .. ; fi
CURRENTDIR=$(pwd)

#color
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'


function Copy_Bin(){
   echo -e "${CYAN}Copy bin files...${NC}"
   if [ ! -d $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX) ]; then mkdir $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX); fi
   cp $HOMEFOLDER/nkn/nknd $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX)/.
   cp $HOMEFOLDER/nkn/nknc $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX)/.
   if [ -e $HOMEFOLDER/ChainDB ]; then
        if [ -e $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX)/ChainDB ]; then
         echo -n -e "${YELLOW}ChainDB folder ${RED}exist${YELLOW}. Do you want to overwrite[${PURPLE}Y;n${YELLOW}]:${NC}"
         read ANSWER;
         if [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]; then
           echo -e "${CYAN}Copy ChainDB...${NC}"
           rsync --progress -r $HOMEFOLDER/ChainDB $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX) | tr '\n' '\r'
           echo
         else 
           echo -e "${CYAN}Skip ChainDB copying...${NC}"
         fi
         else
           echo -e "${CYAN}Copy ChainDB...${NC}"
           rsync --progress -r $HOMEFOLDER/ChainDB $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX) | tr '\n' '\r'
           echo
         fi
     fi
}

function Config_Create(){
echo -n -e "${YELLOW}Input Your BeneficiaryAddr[${PURPLE}$ADDRESS${YELLOW}]:${NC}"
read -e ADDR
if [ ! -z $ADDR ]; then ADDRESS=$ADDR; fi
echo -n -e "${YELLOW}Input Your RegisterIDTxnFee in sat[${PURPLE}$IDTXFEE${YELLOW}]:${NC}"
read -e IDTXFE
if [ ! -z $IDTXFE ]; then IDTXFEE=$IDTXFE; fi
if [[ ! ${IDTXFEE} =~ ^[0-9]+$ ]] ; then IDTXFEE=1 ; fi
if [ -f $FCONFIG ]; then rm $FCONFIG ; fi
cat << EOF > $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX)/$FCONFIG
{
  "BeneficiaryAddr": "$ADDRESS",
  "RegisterIDTxnFee": $IDTXFEE,
  "StatePruningMode": "lowmem",
  "SeedList": [
    "http://mainnet-seed-0001.nkn.org:30003",
    "http://mainnet-seed-0002.nkn.org:30003",
    "http://mainnet-seed-0003.nkn.org:30003",
    "http://mainnet-seed-0004.nkn.org:30003",
    "http://mainnet-seed-0005.nkn.org:30003",
    "http://mainnet-seed-0006.nkn.org:30003",
    "http://mainnet-seed-0007.nkn.org:30003",
    "http://mainnet-seed-0008.nkn.org:30003",
    "http://mainnet-seed-0009.nkn.org:30003",
    "http://mainnet-seed-0010.nkn.org:30003",
    "http://mainnet-seed-0011.nkn.org:30003",
    "http://mainnet-seed-0012.nkn.org:30003",
    "http://mainnet-seed-0013.nkn.org:30003",
    "http://mainnet-seed-0014.nkn.org:30003",
    "http://mainnet-seed-0015.nkn.org:30003",
    "http://mainnet-seed-0016.nkn.org:30003",
    "http://mainnet-seed-0017.nkn.org:30003",
    "http://mainnet-seed-0018.nkn.org:30003",
    "http://mainnet-seed-0019.nkn.org:30003",
    "http://mainnet-seed-0020.nkn.org:30003",
    "http://mainnet-seed-0021.nkn.org:30003",
    "http://mainnet-seed-0022.nkn.org:30003",
    "http://mainnet-seed-0023.nkn.org:30003",
    "http://mainnet-seed-0024.nkn.org:30003",
    "http://mainnet-seed-0025.nkn.org:30003",
    "http://mainnet-seed-0026.nkn.org:30003",
    "http://mainnet-seed-0027.nkn.org:30003",
    "http://mainnet-seed-0028.nkn.org:30003",
    "http://mainnet-seed-0029.nkn.org:30003",
    "http://mainnet-seed-0030.nkn.org:30003",
    "http://mainnet-seed-0031.nkn.org:30003",
    "http://mainnet-seed-0032.nkn.org:30003",
    "http://mainnet-seed-0033.nkn.org:30003",
    "http://mainnet-seed-0034.nkn.org:30003",
    "http://mainnet-seed-0035.nkn.org:30003",
    "http://mainnet-seed-0036.nkn.org:30003",
    "http://mainnet-seed-0037.nkn.org:30003",
    "http://mainnet-seed-0038.nkn.org:30003",
    "http://mainnet-seed-0039.nkn.org:30003",
    "http://mainnet-seed-0040.nkn.org:30003",
    "http://mainnet-seed-0041.nkn.org:30003",
    "http://mainnet-seed-0042.nkn.org:30003",
    "http://mainnet-seed-0043.nkn.org:30003",
    "http://mainnet-seed-0044.nkn.org:30003"
  ],
  "GenesisBlockProposer": "a0309f8280ca86687a30ca86556113a253762e40eb884fc6063cad2b1ebd7de5"
}
EOF
}

function Create_Wallet(){
if [ -f $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX)/$FWALLET ] ; then
        echo -e "${RED}Wallet already exist!${NC}"
        echo -n -e "${YELLOW}Input your wallet password[${PURPLE}$WPASSWORD${YELLOW}]:${NC}"
        read -e WPASS
        if [ ! -z $WPASS ]; then WPASSWORD=$WPASS; fi
        else
        cd $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX)
        echo -e "${CYAN}Create new wallet...${NC}"
        echo -n -e "${YELLOW}Input your wallet password[${PURPLE}$WPASSWORD${YELLOW}]:${NC}"
        read -e WPASS
        if [ ! -z $WPASS ]; then WPASSWORD=$WPASS; fi
        echo -e "${GREEN}"
        ./nknc wallet -c -p $WPASSWORD
        echo -e "${NC}"
        cd $HOMEFOLDER
        echo -e -n "${YELLOW}Send $IDTXFEE satoshi to this address and press <ENTER>:${NC}"; read
fi
}


echo -e "${CYAN}Preparing the system for installation...${NC}"
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
sudo apt-get update
sudo apt-get install unzip -y
sudo apt-get install -y golang-go
sudo apt-get update
sudo apt-get install -y docker-engine

if [ ! -d $HOMEFOLDER ]; then mkdir $HOMEFOLDER; fi
cd $HOMEFOLDER
if [ -f $DIR_NAME.zip ]; then rm $DIR_NAME.zip ; fi
echo '#!/bin/bash' > $START_SCRIPT
if [ -f $DIR_LIST ]; then rm $DIR_LIST; fi
if [ -f $IP_LIST ]; then rm $IP_LIST; fi

if [ -d nkn ]; then cd nkn; git merge;
else git clone $GITPATH; cd nkn; fi

LATEST_TAG=$(git tag --sort=-creatordate | head -1)

if [ -f nknd ]; then
        echo -e "${RED}Bin files exist!${NC}"
        else
        echo -e "${BLUE}Downloading bin files...${NC}"
        wget "$RELEASES_PATH/$LATEST_TAG/$DIR_NAME.zip"
        if [ -f $DIR_NAME.zip ]; then
                echo -e "${MAG}Unzipping bin files...${NC}"
                unzip $DIR_NAME.zip >/dev/null 2>&1
                chmod +x $DIR_NAME/nkn*
                cp $DIR_NAME/nkn* .
                rm -rf $DIR_NAME.zip $DIR_NAME
        else
                echo -e -n "${YELLOW}Bin files not found. Do you want to compile? [${PURPLE}Y,n${YELLOW}]:${NC}"
                read  ANSWER
                if [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]; then
                        make
                 fi
        fi
fi
cd $HOMEFOLDER
if [ -e ChainDB_pruned_latest.zip ];then rm -f ChainDB_pruned_latest.zip; fi
if [ -e $HOMEFOLDER/ChainDB ]; then
   echo -e -n "${YELLOW}Straps dir ChainDB ${RED}exist${YELLOW}. Download anyway?[${PURPLE}Y;n${YELLOW}]:${NC}"
   read ANSWER;
   if [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]; then
      echo -e "${BLUE}Downloading straps...${NC}"
      wget https://nkn.org/ChainDB_pruned_latest.zip
      echo -e "${MAG}Unzipping ChainDB...${NC}"
      unzip ChainDB_pruned_latest.zip | tr '\n' '\r'
      rm -f ChainDB_pruned_latest.zip
      fi
else 
   echo -e -n "${YELLOW}Do you want to download bootstrap file? [${PURPLE}Y,n${YELLOW}]:${NC}"
   read ANSWER
   if [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]; then
      echo -e "${BLUE}Downloading straps...${NC}"
      wget https://nkn.org/ChainDB_pruned_latest.zip
      echo -e "${MAG}Unzipping ChainDB...${NC}"
      unzip ChainDB_pruned_latest.zip | tr '\n' '\r'
      rm -f ChainDB_pruned_latest.zip
    fi
fi

ANSWER="y"
while [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ] 
do
echo -e "${GREEN}$NODEDIR$(printf "%0*d\n" 3 $INDEX) node setuping:${NC}"
Copy_Bin
Config_Create
Create_Wallet
echo -e -n "${YELLOW}Input IP address[${PURPLE}$IP_ADDRESS${YELLOW}]:${NC}"; read -e IP_ADDR
if [ ! -z $IP_ADDR ]; then IP_ADDRESS=$IP_ADDR; fi
#if [ -d 'ChainDB' ]; then 
#   echo -e "${CYAN}Copying strap files, please wait...${NC}"
#   cp -r ChainDB $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX)/; fi
#cd $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX)
#cd $HOMEFOLDER
echo -e "${CYAN}Writing a startup script...${NC}"
echo -e "docker run -d -p $IP_ADDRESS:30001-30003:30001-30003 -v $CURRENTDIR/$NODEDIR$(printf "%0*d\n" 3 $INDEX):/nkn --name $NODEDIR$(printf "%0*d\n" 3 $INDEX) -w /nkn --rm -it nknorg/nkn /nkn/nknd -p $WPASSWORD" >> $START_SCRIPT
echo -e $NODEDIR$(printf "%0*d\n" 3 $INDEX) >> $DIR_LIST
((INDEX++))
echo -e -n "${YELLOW}Do you want to set up another docker container?[${PURPLE}Y,n${YELLOW}]:${NC}"; read -e ANSWER
done
echo -e "${CYAN}Write crontab...${NC}"
sudo crontab -l -u root > cron
if ! cat cron | grep "$HOMEFOLDER/$START_SCRIPT"; then echo -e "@reboot bash $HOMEFOLDER/$START_SCRIPT" >> cron; fi
if ! cat cron | grep "$HOMEFOLDER/dockercheck.sh"; then echo -e "0 */2 * * * cd $HOMEFOLDER && bash $HOMEFOLDER/dockercheck.sh >/dev/null 2>&1" >> cron; fi
sudo crontab -u root cron
rm cron

echo -e "${CYAN}Creating checking script...${NC}"
echo  '#!/bin/bash' > dockercheck.sh
echo -e "cd $HOMEFOLDER" >> dockercheck.sh
echo  'exec {DIR_LIST}<dir.list' >> dockercheck.sh
echo  'exec {START_SCRIPT}<nknstart.sh' >> dockercheck.sh
echo  -e "if [ -d nkn ]; then cd nkn; git fetch; else git clone $GITPATH; cd nkn; fi" >> dockercheck.sh
echo  'LATEST_TAG=$(git tag --sort=-creatordate | head -1)' >> dockercheck.sh
echo  'read -r -u "$START_SCRIPT" START_COM' >> dockercheck.sh
echo  'while read -r -u "$DIR_LIST" DOCKER_NAME && read -r -u "$START_SCRIPT" START_COM' >> dockercheck.sh
echo  'do' >> dockercheck.sh
echo  -n 'if [[ -z $(' >> dockercheck.sh
echo -e -n "$CURRENTDIR" >> dockercheck.sh
echo  '/$DOCKER_NAME/nknd -v | grep $LATEST_TAG) ]]; then' >> dockercheck.sh
echo  '  docker stop $DOCKER_NAME' >> dockercheck.sh
echo  '  if [ -f $DIR_NAME.zip ]; then' >> dockercheck.sh
echo -e "rm $DIR_NAME.zip; fi" >> dockercheck.sh
echo -e -n "  wget $RELEASES_PATH" >> dockercheck.sh
echo  -n '/$LATEST_TAG/' >> dockercheck.sh
echo  '$DIR_NAME.zip' >> dockercheck.sh
echo -n '  if [ $? -ne 0 ]; then make; ' >> dockercheck.sh
echo -e "else unzip "$DIR_NAME.zip" >/dev/null 2>&1; mv $DIR_NAME/nkn* .; rm -rf $DIR_NAME $DIR_NAME.zip; fi" >> dockercheck.sh
echo  '  chmod +x nknd; chmod +x nknc' >> dockercheck.sh
echo  '  cp nknd nknc ../../$DOCKER_NAME' >> dockercheck.sh
echo  '  rm -rf ../../$DOCKER_NAME/Log' >> dockercheck.sh
echo  '  $START_COM' >> dockercheck.sh
echo  'fi' >> dockercheck.sh
echo  '   docker top $DOCKER_NAME | grep nknd' >> dockercheck.sh
echo  '   if [ $? -ne 0 ]; then rm -rf ../../$DOCKER_NAME/Log; $START_COM ; fi' >> dockercheck.sh
echo  'done' >> dockercheck.sh

chmod +x $HOMEFOLDER/*.sh
rm -rf $HOMEFOLDER/ChainDB
rm -rf $CURRENTDIR/nkn
cd $CURRENTDIR
echo -e -n "${YELLOW}Do you want to start docker containers[${PURPLE}Y,n${YELLOW}]?:${NC}"
read ANSWER
if [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]; then
sudo bash $HOMEFOLDER/$START_SCRIPT
fi
echo -e "${GREEN}All Done!${NC}"

