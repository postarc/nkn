#!/bin/bash

GITPATH="https://github.com/nknorg/nkn.git"
RELEASES_PATH="https://github.com/nknorg/nkn/releases/download"
DIR_NAME="linux-amd64"
FCONFIG="config.json"
FWALLET="wallet.json"
IDTXFEE=1


#color
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

apt --help > /dev/null
if [ $? -eq 0 ]; then
      sudo apt update
      APPGET="apt"
else
      yum --help > /dev/null
      if [ $? -eq 0 ]; then
         sudo yum check-update
         APPGET="yum"
      fi
fi


if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root/nkn-node"
#       echo -e "${RED}Do not install node in the root folder, please create new user${NC}"
#        exit 0
 else
        HOMEFOLDER="/home/$USER/nkn-node"
fi

sudo $APPGET install unzip wget -y 
CURRENTDIR=$(pwd)
if [ -d $HOMEFOLDER ] ; then cd $HOMEFOLDER ; else mkdir $HOMEFOLDER; cd $HOMEFOLDER; fi

if [ -d nkn ]; then 
  cd nkn
  git merge
  else
  git clone $GITPATH
  cd nkn
fi
# LATEST_TAG=$(git tag --sort=-creatordate | head -1) 
LATEST_TAG=$(git tag | sort -d | tail -n 1)
cd ..

if [ -f $DIR_NAME.zip ]; then rm $DIR_NAME.zip ; fi
if [ -f nknd ]; then
        echo -e "${RED}Bin files exist!${NC}"
        else
        echo -e "${CYAN}Downloading bin files...${NC}"
        wget "$RELEASES_PATH/$LATEST_TAG/$DIR_NAME.zip"
        if [ -f $DIR_NAME.zip ]; then 
                echo -e "${MAG}Unzipping bin files...${NC}"
                unzip $DIR_NAME.zip >/dev/null 2>&1
                echo -e "${BLUE}Moving bin files...${NC}"
                mv $DIR_NAME/nkn* .
                mv $DIR_NAME/certs .
                mv $DIR_NAME/web .
                rm -rf $DIR_NAME
                rm $DIR_NAME.zip
        else
                echo -e "${YELLOW}Bin files not found. Do you want to compile? [Y,n]:${NC}"
                read -e ANSWER
                if [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]; then
                        sudo $APPGET update
                        sudo $APPGET install -y golang-go
                        cd $HOMEFOLDER/nkn
                        make
                        mv nknd ..
                        mv nknc ..
                        cd $HOMEFOLDER
                 fi
        fi
fi
echo -n -e "${YELLOW}Input Your BeneficiaryAddr:${NC}"
read -e ADDRESS
echo -n -e "${YELLOW}Input Your RegisterIDTxnFee in sat(default 0 for free ID generating):${NC}"
read -e IDTXFEE
REGID=""
if [[ ! ${IDTXFEE} =~ ^[0-9]+$ ]] ; then IDTXFEE=0
else 
   if [ ${IDTXFEE} -gt 0 ]; then
       REGID='"RegisterIDTxnFee": '$IDTXFEE','
   fi
fi
echo
if [ -f $FCONFIG ]; then rm $FCONFIG ; fi
cat << EOF > $FCONFIG
{
  "BeneficiaryAddr": "$ADDRESS",
  $REGID
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
sleep 2
if [ -f $FWALLET ] ; then
        echo -e "${RED}Wallet already exist!${NC}"
        echo -n -e "${YELLOW}Input your wallet password:${NC}"
        read -e WPASSWORD        
else
        echo -e "${CYAN}Create new wallet...${NC}"
        echo -n -e "${YELLOW}Input your wallet password:${NC}"
        read -e WPASSWORD
        echo -e "${GREEN}"
        ./nknc wallet -c -p $WPASSWORD
        echo -e "${NC}"
        if [ $IDTXFEE -gt 0 ]; then 
           echo -n -e "${YELLOW}Send $IDTXFEE sat nkn to address and press <ENTER>${NC}"
           read -e ANSWER
        fi
        
fi
sleep 2
echo -e "${CYAN}Creating nkn service...${NC}"

echo "[Unit]" > nkn.service
echo "Description=nkn" >> nkn.service
echo "[Service]" >> nkn.service
echo -e "User=$USER" >> nkn.service
echo -e "WorkingDirectory=$HOMEFOLDER" >> nkn.service
echo -e "ExecStart=$HOMEFOLDER/nknd -p $WPASSWORD" >> nkn.service
echo "Restart=always" >> nkn.service
echo "RestartSec=3" >> nkn.service
echo "LimitNOFILE=500000" >> nkn.service
echo "[Install]" >> nkn.service
echo "WantedBy=default.target" >> nkn.service

sudo cp nkn.service /etc/systemd/system/nkn.service
sudo systemctl enable nkn.service

rm nkn.service

echo -e "${CYAN}firewall setup...${NC}"
sudo ufw allow 30001/tcp
sudo ufw allow 30002/tcp
sudo ufw allow 30003/tcp
sudo ufw allow 30004/tcp
sudo ufw allow 30005/tcp

echo -e -n "${YELLOW}Do you want to download bootstrap file? [Y,n]: ${NC}"
read -e ANSWER
if [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]; then
        cd $HOMEFOLDER
        wget https://nkn.org/ChainDB_pruned_latest.zip
        unzip ChainDB_pruned_latest.zip | tr '\n' '\r'
        rm -rf ChainDB_pruned_latest.zip
fi       

echo -e "${CYAN}Starting nkn service...${NC}"
sudo systemctl start nkn.service
echo
#echo -e "${GREEN}"
#./nknc wallet -l account -p $WPASSWORD
#echo -e "${NC}"
echo -e "${MAG}Nkn node control:${NC}"
echo -e "${CYAN}Start nkn node: ${BLUE}sudo systemctl start nkn.service${NC}"
echo -e "${CYAN}Stop nkn node: ${BLUE}sudo systemctl stop nkn.service${NC}"
echo -e "${CYAN}Enabe nkn service: ${BLUE}sudo systemctl enable nkn.service${NC}"
echo -e "${CYAN}Disable nkn service: ${BLUE}sudo systemctl disable nkn.service${NC}"
echo -e "${CYAN}Status nkn node: ${BLUE}sudo systemctl status nkn.service${NC}"
echo -e "${BLUE}or use command ./nknc info --state for statistics${NC}"
echo -e "${CYAN}For nkn.service file editing: ${BLUE}sudo nano /etc/systemd/system/nkn.service${NC}"
echo -e "${CYAN}After editing nkn.service file: ${BLUE}sudo systemctl daemon-reload${NC}"

cd $CURRENTDIR
bash nkn/autoupdate.sh
rm -rf nkn

