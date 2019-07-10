#!/bin/bash

SCRIPT_NAME="nknupdate.sh"

if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root/nkn-node"
 else
        HOMEFOLDER="/home/$USER/nkn-node"
fi

CURRENTDIR=$(pwd)

if [[ -z $(sudo -u root crontab -l | grep '/nknupdate.sh') ]]; then
        sudo -u root crontab -l > cron
        echo -e "0 */2 * * * $HOMEFOLDER/nknupdate.sh >/dev/null 2>&1" >> cron
        sudo -u root crontab cron
fi

cat << EOF > $SCRIPT_NAME
#!/bin/bash

GITPATH="https://github.com/nknorg/nkn.git"
RELEASES_PATH="https://github.com/nknorg/nkn/releases/download"
DIR_NAME="linux-amd64"
CURRENTDIR=$(pwd)
EOF

echo -e "cd $HOMEFOLDER" >> $SCRIPT_NAME

cat << EOF >> $SCRIPT_NAME
if [ -d nkn ]; then
  cd nkn
  git merge
  else
  git clone $GITPATH
  cd nkn
fi
LATEST_TAG=$(git tag --sort=-creatordate | head -1)
cd ..
EOF

echo -e "if [[ -z $($HOMEFOLDER/nknd -v | grep $LATEST_TAG) ]]; then" >> $SCRIPT_NAME
echo -e "  sudo -u $USER systemctl stop nkn.service" >> $SCRIPT_NAME

cat << EOF >> $SCRIPT_NAME  
  wget "$RELEASES_PATH/$LATEST_TAG/$DIR_NAME.zip"
  unzip "$DIR_NAME.zip"
  chmod +x $DIR_NAME/nkn*
  mv $DIR_NAME/nkn* .
EOF

echo -e "  sudo -u nkn systemctl start nkn.service" >> $SCRIPT_NAME

cat << EOF >> $SCRIPT_NAME 
  rm -rf $DIR_NAME $DIR_NAME.zip
fi
cd $CURRENTDIR
EOF

cd $CURRENTDIR
rm -rf nkn
