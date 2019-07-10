#!/bin/bash

SCRIPT_NAME="nknupdate.sh"

if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root/nkn-node"
 else
        HOMEFOLDER="/home/$USER/nkn-node"
fi

CURRENTDIR=$(pwd)
cd $HOMEFOLDER

if [[ -z $(sudo -u root crontab -l | grep "nknupdate.sh") ]]; then
        sudo -u root crontab -l > cron
        echo -e "0 */2 * * * $HOMEFOLDER/nknupdate.sh >/dev/null 2>&1" >> cron
        sudo -u root crontab cron
        rm cron
fi

echo "#!/bin/bash\nGITPATH="https://github.com/nknorg/nkn.git"\nRELEASES_PATH="https://github.com/nknorg/nkn/releases/download"\nDIR_NAME="linux-amd64"\nCURRENTDIR=$(pwd)" > $SCRIPT_NAME
echo -e "cd $HOMEFOLDER" >> $SCRIPT_NAME

echo "if [ -d nkn ]; then\n  cd nkn\n  git merge\n  else\n  git clone $GITPATH\n  cd nkn\nfi\nLATEST_TAG=$(git tag --sort=-creatordate | head -1)\ncd .." >> $SCRIPT_NAME
echo -e "if [[ -z $($HOMEFOLDER/nknd -v | grep $LATEST_TAG) ]]; then" >> $SCRIPT_NAME
echo -e "  sudo -u $USER systemctl stop nkn.service" >> $SCRIPT_NAME
echo "  wget "$RELEASES_PATH/$LATEST_TAG/$DIR_NAME.zip"\n  unzip "$DIR_NAME.zip"\n  chmod +x $DIR_NAME/nkn*\n  mv $DIR_NAME/nkn* ." >> $SCRIPT_NAME
echo -e "  sudo -u nkn systemctl start nkn.service" >> $SCRIPT_NAME
echo "  rm -rf $DIR_NAME $DIR_NAME.zip\nfi\ncd $CURRENTDIR" >> $SCRIPT_NAME

cd $CURRENTDIR
rm -rf nkn
