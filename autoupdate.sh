#!/bin/bash

if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root/nkn-node"
 else
        HOMEFOLDER="/home/$USER/nkn-node"
fi 

CURRENTDIR=$(pwd)
chmod +x nkn/nknupdate.sh
cp nkn/nknupdate.sh $HOMEFOLDER/

if [ crontab -l | grep "$HOMEFOLDER/nknupdate.sh" ]; then exit; else
        crontab -l > cron
        echo -e "00 12 * * * $HOMEFOLDER/nknupdate.sh >/dev/null 2>&1" >> cron
        crontab cron
fi

cd $CURRENTDIR
rm -rf nkn
