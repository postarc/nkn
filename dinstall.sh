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
        echo -e "${YELLOW}Copy bin files...${NC}"
        if [ ! -d $CURRENTDIR/$NODEDIR$INDEX ]; then mkdir $CURRENTDIR/$NODEDIR$INDEX; fi
        cp $HOMEFOLDER/nkn/nknd $CURRENTDIR/$NODEDIR$INDEX/.
        cp $HOMEFOLDER/nkn/nknc $CURRENTDIR/$NODEDIR$INDEX/.
}

function Config_Create(){
echo -n -e "${YELLOW}Input Your BeneficiaryAddr[$ADDRESS]:${NC}"
read -e ADDR
if [ -n $ADDR ]; then ADDRESS=$ADDR; fi
echo -n -e "${YELLOW}Input Your RegisterIDTxnFee in sat[1]:${NC}"
read -e IDTXFEE
if [[ ! ${IDTXFEE} =~ ^[0-9]+$ ]] ; then IDTXFEE=1 ; fi
echo
if [ -f $FCONFIG ]; then rm $FCONFIG ; fi
cat << EOF > $CURRENTDIR/$NODEDIR$INDEX/$FCONFIG
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
if [ -f $CURRENTDIR/$NODEDIR$INDEX/$FWALLET ] ; then
        echo -e "${RED}Wallet already exist!${NC}"
        echo -n -e "${YELLOW}Input your wallet password:${NC}"
        read -e WPASSWORD
        else
        cd $CURRENTDIR/$NODEDIR$INDEX
        echo -e "${YELLOW}Create new wallet...${NC}"
        echo -n -e "${YELLOW}Input your wallet password:${NC}"
        read -e WPASSWORD
        ./nknc wallet -c -p $WPASSWORD
        cd $HOMEFOLDER
fi
}


echo -e "${CYAN}Preparing the system for installation...${NC}"
#sudo add-apt-repository -y ppa:longsleep/golang-backports
#sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D -y
#sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' -y
#sudo apt-get update
#sudo apt-get install unzip -y
#sudo apt-get install -y golang-go
#sudo apt-get install -y docker-engine

if [ ! -d $HOMEFOLDER ]; then mkdir $HOMEFOLDER; fi
cd $HOMEFOLDER
if [ -d nkn ]; then cd nkn; git merge;
else git clone $GITPATH; cd nkn; fi

LATEST_TAG=$(git tag --sort=-creatordate | head -1)

if [ -f $DIR_NAME.zip ]; then rm $DIR_NAME.zip ; fi
if [ -f $START_SCRIPT ]; then rm $START_SCRIPT; fi
if [ -f $DIR_LIST ]; then rm $DIR_LIST; fi
if [ -f $IP_LIST ]; then rm $IP_LIST; fi
if [ -f nknd ]; then
        echo -e "${RED}Bin files exist!${NC}"
        else
        echo -e "${YELLOW}Downloading bin files...${NC}"
        wget "$RELEASES_PATH/$LATEST_TAG/$DIR_NAME.zip"
        if [ -f $DIR_NAME.zip ]; then
                echo -e "${YELLOW}Unzipping bin files...${NC}"
                unzip $DIR_NAME.zip >/dev/null 2>&1
                chmod +x $DIR_NAME/nkn*
                cp $DIR_NAME/nkn* .
                rm -rf $DIR_NAME.zip $DIR_NAME
        else
                read -e -p "Bin files not found. Do you want to compile? [Y,n]: " ANSWER
                if [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]; then
                        make
                 fi
        fi
fi
read -e -p "Do you want to download bootstrap file? [Y,n]: " ANSWER
if [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]; then
        cd $HOMEFOLDER
        wget https://nkn.org/ChainDB_pruned_latest.zip
        unzip ChainDB_pruned_latest.zip | tr '\n' '\r'
        rm -rf ChainDB_pruned_latest.zip
fi
ANSWER="y"
while [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]
do
Copy_Bin
Config_Create
Create_Wallet
echo -e -n "${MAG}Input IP address[$IP_ADDRESS]:${NC}"; read -e IP_ADDR
if [ -n $IP_ADDR ]; then IP_ADDRESS=$IP_ADDR; fi
if [ -d 'ChainDB' ]; then cp -r ChainDB $CURRENTDIR/$NODEDIR$INDEX/; fi
cd $CURRENTDIR/$NODEDIR$INDEX
echo -e "${YELLOW}"
./nknc wallet -l account -p $WPASSWORD
echo -e "${NC}"
cd $HOMEFOLDER
echo -e -n "${CYAN}Send $IDTXFEE satoshi to this address and press <ENTER>${NC}"; read
echo -e "${GREEN}Create a startup script...${NC}"
echo -e "docker run -d -p $IP_ADDRESS:30001-30003:30001-30003 -v $CURRENTDIR/$NODEDIR$INDEX:/nkn --name $NODEDIR$INDEX -w /nkn --rm -it nknorg/nkn /nkn/nknd -p $WPASSWORD" >> START_SCRIPT
#echo -e $IP_ADDRESS >> $IP_LIST
echo -e $$NODEDIR$INDEX >> $DIR_LIST
echo -e -n "Do you want to set up another docker container?[Y,n]:"; read -e ANSWER
done
echo -e "${YELLOW}Write crontab...${NC}"
sudo crontab -l -u root > cron
if ! cat cron | grep "$HOMEFOLDER/$START_SCRIPT"; then echo -e "@reboot bash $HOMEFOLDER/$START_SCRIPT" >> cron; fi
if ! cat cron | grep "$HOMEFOLDER/dockercheck.sh"; then echo -e "0 */2 * * * cd $HOMEFOLDER && bash $HOMEFOLDER/dockercheck.sh >/dev/null 2>&1" >> cron; fi
sudo crontab -u root cron
cp $CURRENTDIR/nkn/dockercheck.sh $HOMEFOLDER
chmod +x $HOMEFOLDER/*.sh
#cd $CURRENTDIR
#rm -rf nkn
