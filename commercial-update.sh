#!/bin/bash

#GITPATH="https://github.com/nknorg/nkn.git"
RELEASES_PATH="https://commercial.nkn.org/downloads/nkn-commercial"
SERVICE_PATH="services/nkn-node"
SYSTEMD_PATH="/etc/systemd/system"
SERVICE_NAME="nkn.service"
BIN_NAME="nkn-commercial"
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
wget $RELEASES_PATH/$DIR_NAME.zip
unzip $DIR_NAME.zip
mv $DIR_NAME/* ./
rm -rf $DIR_NAME*

# Firewall setup
sudo ufw allow 30001:30005/tcp
sudo ufw allow 30010,30020/tcp 
sudo ufw allow 30011,30021/udp
sudo ufw allow 32768:65535/tcp
sudo ufw allow 32768:65535/udp

mv ../nkn-node/* $SERVICE_PATH/*
if [ -f $SYSTEMD_PATH/$SERVICE_NAME ]; then 
        PASSWD=$(sudo cat $SYSTEMD_PATH/$SERVICE_NAME | grep nknd | awk '{print $3}')
        echo $PASSWD > $SERVICE_PATH/wallet.pswd
        HOMEDIR=ExecStart=$(echo $HOMEFOLDER | sed 's/'\\/'/'\\\\''\\/'/g')\\/$BIN_NAME
        sed -i "s/.*nknd.*/$HOMEDIR/" $SYSTEMD_PATH/$SERVICE_NAME
        HOMEDIR='WorkingDirectory='$(echo $HOMEFOLDER | sed 's/'\\/'/'\\\\''\\/'/g')
        sed -i "s/.*WorkingDirectory.*/$HOMEDIR/" $SYSTEMD_PATH/$SERVICE_NAME
        sudo systemctl daemon-reload
else
       echo -e "${RED}Service not found. Creating new service. ${NC}"
       echo "[Unit]" > $SERVICE_NAME
       echo "Description=nkn" >> $SERVICE_NAME
       echo "[Service]" >> $SERVICE_NAME
       echo -e "User=$USER" >> $SERVICE_NAME
       echo -e "WorkingDirectory=$HOMEFOLDER" >> $SERVICE_NAME
       echo -e "ExecStart=$HOMEFOLDER/$BIN_NAME" >> $SERVICE_NAME
       echo "Restart=always" >> $SERVICE_NAME
       echo "RestartSec=5" >> $SERVICE_NAME
       echo "LimitNOFILE=500000" >> $SERVICE_NAME
       echo "[Install]" >> $SERVICE_NAME
       echo "WantedBy=default.target" >> $SERVICE_NAME
       sudo cp $SERVICE_NAME $SYSTEMD_PATH/$SERVICE_NAME 
       rm $SERVICE_NAME
fi

        
#rmdir  ../nkn-node
