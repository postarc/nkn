#!/bin/bash

if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root/nkn-node"
 else
        HOMEFOLDER="/home/$USER/nkn-node"
fi

CURRENTDIR=$(pwd)
chmod +x nkn/nknupdate.sh
cp nkn/nknupdate.sh $HOMEFOLDER/

if [[ -z $(sudo -u root crontab -l | grep '/nknupdate.sh') ]]; then
        sudo -u root crontab -l > cron
        echo -e "0 */2 * * * $HOMEFOLDER/nknupdate.sh >/dev/null 2>&1" >> cron
        sudo -u root crontab cron
fi

cd $CURRENTDIR
rm -rf nkn
