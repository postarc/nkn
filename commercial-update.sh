#!/bin/bash

#GITPATH="https://github.com/nknorg/nkn.git"
RELEASES_PATH="https://commercial.nkn.org/downloads/nkn-commercial"
SERVICE_PATH="services/nkn-node"
SYSTEMD_PATH="/etc/systemd/system"
SERVICE_NAME="nkn.service"
DIR_NAME="linux-amd64"
FCONFIG="config.json"
FWALLET="wallet.json"
#IDTXFEE=1
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

if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root/nkn-commercial"
#       echo -e "${RED}Do not install node in the root folder, please create new user${NC}"
#        exit 0
 else
        HOMEFOLDER="/home/$USER/nkn-commercial"
fi
if [ -d $HOMEFOLDER ] ; then cd $HOMEFOLDER ; else mkdir $HOMEFOLDER; cd $HOMEFOLDER; fi 

# Download bin files & unzip
wget https://commercial.nkn.org/downloads/nkn-commercial/linux-amd64.zip
unzip linux-amd64.zip
mv linux-amd64/* ./
rm -rf linux-amd64*

# Firewall setup
sudo ufw allow 30001:30005/tcp
sudo ufw allow 30010,30020/tcp 
sudo ufw allow 30011,30021/udp
sudo ufw allow 32768:65535/tcp
sudo ufw allow 32768:65535/udp

mv ../nkn-node/* $SERVICE_PATH/*
PASSWD=$(sudo cat $SYSTEMD_PATH/$SERVICE_NAME | grep nknd | awk '{print $3}')
echo $PASSWD > $SERVICE_PATH/wallet.pswd
#rmdir  ../nkn-node
sudo rm $SYSTEMD_PATH/$SERVICE_NAME
