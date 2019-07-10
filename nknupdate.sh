#!/bin/bash

GITPATH="https://github.com/nknorg/nkn.git"
RELEASES_PATH="https://github.com/nknorg/nkn/releases/download"
DIR_NAME="linux-amd64"


if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root/nkn-node"
 else
        HOMEFOLDER="/home/$USER/nkn-node"
fi

CURRENTDIR=$(pwd)
cd $HOMEFOLDER
if [ -d nkn ]; then
  cd nkn
  git merge
  else
  git clone $GITPATH
  cd nkn
fi
LATEST_TAG=$(git tag --sort=-creatordate | head -1)
cd ..

if [ ./nknd -v | grep $LATEST_TAG ]; then exit
else
  sudo systemctl stop nkn.service
  wget "$RELEASES_PATH/$LATEST_TAG/$DIR_NAME.zip"
  unzip "$DIR_NAME.zip"
  chmod +x $DIR_NAME/nkn*
  mv $DIR_NAME/nkn* .
  sudo systemctl start nkn.service
  rm -rf $DIR_NAME $DIR_NAME.zip
fi
cd $CURRENTDIR
