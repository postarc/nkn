#!/bin/bash

GITPATH="https://github.com/nknorg/nkn.git"
ARCHIVE="https://github.com/nknorg/nkn/releases/download/v1.0.2-beta/linux-amd64.zip"
FNAME="linux-amd64.zip"
APATH="linux-amd64"
FCONFIG="config.json"
FWALLET="wallet.json"

if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root/nkn-node"
 else
        HOMEFOLDER="/home/$USER/nkn-node"
fi 

chmod +x nknupdate.sh
cp nkn/nknupdate.sh $HOMEFOLDER/

if [ crontab -l | grep "$HOMEFOLDER/nknupdate.sh" ]; then exit; else
        crontab -l > cron
        echo -e "00 12 * * * $HOMEFOLDER/nknupdate.sh >/dev/null 2>&1" >> cron
        crontab cron
fi


sudo systemctl stop nkn.service
cd $HOMEFOLDER
wget $ARCHIVE
unzip $FNAME >/dev/null 2>&1
mv $APATH/nkn* .
rm -rf $APATH
rm $FNAME

sudo systemctl start nkn.service

cd $CURRENTDIR
rm -rf nkn
