#!/bin/bash

ARCHIVE="https://github.com/nknorg/nkn/releases/download/v1.0.1b-beta/linux-amd64.zip"
FNAME="linux-amd64.zip"
APATH="linux-amd64"
FCONFIG="config.json"
FWALLET="wallet.json"

#color
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root/nkn-node"
 else
        HOMEFOLDER="/home/$USER/nkn-node"
fi
CURRENTDIR=$(pwd)
if [ -d $HOMEFOLDER ] ; then cd $HOMEFOLDER ; else mkdir $HOMEFOLDER; cd $HOMEFOLDER; fi
if [ -f $FNAME ]; then rm $FNAME ; fi
if [ -f nknd ]; then
        echo -e "${RED}Bin files exist!${NC}"
        else
        echo -e "${YELLOW}Downloading bin files...${NC}"
        wget $ARCHIVE
        echo -e "${YELLOW}Unzipping bin files...${NC}"
        unzip $FNAME >/dev/null 2>&1
        echo -e "${YELLOW}Moving bin files...${NC}"
        mv $APATH/nkn* .
        rm -rf $APATH
        rm $FNAME ; fi

echo -n -e "${YELLOW}Input Your BeneficiaryAddr:${NC}"
read -e ADDRESS
echo
if [ -f $FCONFIG ]; then rm $FCONFIG ; fi
cat << EOF > $FCONFIG
{
  "BeneficiaryAddr": "$ADDRESS",
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
        echo -e "${YELLOW}Create new wallet...${NC}"
        echo -n -e "${YELLOW}Input your wallet password:${NC}"
        read -e WPASSWORD
        ./nknc wallet -c -p $WPASSWORD
        fi
sleep 2
echo -e "${YELLOW}Creating nkn service...${NC}"

echo "[Unit]" > nkn.service
echo "Description=nkn" >> nkn.service
echo "[Service]" >> nkn.service
echo "User=nkn" >> nkn.service
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

#echo -e "${YELLOW}Writing new crontab...${NC}"
#if ! crontab -l | grep "/nknd -p"; then
#  (crontab -l ; echo "@reboot $HOMEFOLDER/nknd -p $WPASSWORD") | crontab -
#fi

echo -e "${YELLOW}firewall setup...${NC}"
sudo ufw allow 30001/tcp
sudo ufw allow 30002/tcp
sudo ufw allow 30003/tcp

echo -e "${MAG}Nkn node control:${NC}"
echo -e "${CYAN}Start nkn node: ${PURPLE}sudo systemctl start nkn.service${NC}"
echo -e "${CYAN}Stop nkn node: ${PURPLE}sudo systemctl stop nkn.service${NC}"
echo -e "${CYAN}Enabe nkn service: ${PURPLE}sudo systemctl enable nkn.service${NC}"
echo -e "${CYAN}Disable nkn service: ${PURPLE}sudo systemctl disable nkn.service${NC}"
echo -e "${CYAN}Status nkn node: ${PURPLE}sudo systemctl status nkn.service${NC}"
echo -e "${YELLOW}or use command ./nknc info --state for statistics${NC}"

cd $CURRENTDIR
rm -rf nkn

