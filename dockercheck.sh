#!/bin/bash

GITPATH="https://github.com/nknorg/nkn.git"
RELEASES_PATH="https://github.com/nknorg/nkn/releases/download"
DIR_NAME="linux-amd64"
exec {DIR_LIST}<dir.list
exec {START_SCRIPT}<nknstart.sh
CURRENTDIR=$(PWD)

if [ -d nkn ]; then
  cd nkn
  git fetch
  else
  git clone $GITPATH
  cd nkn
fi

LATEST_TAG=$(git tag --sort=-creatordate | head -1)
cd $CURRENTDIR; cd ..
while read -r -u "$DIR_LIST" DOCKER_NAME && read -r -u "$START_SCRIPT" START_COM
do
if [[ -z $($DIR_NAME/nknd -v | grep $LATEST_TAG) ]]; then
  docker stop $DOCKER_NAME
  if [ -f $DIR_NAME.zip ]; then rm $DIR_NAME.zip; fi
  wget "$RELEASES_PATH/$LATEST_TAG/$DIR_NAME.zip"
  if [ $? -ne 0 ]; then
  make
  else
  unzip "$DIR_NAME.zip" >/dev/null 2>&1
  mv $DIR_NAME/nkn* .
  rm -rf $DIR_NAME $DIR_NAME.zip
  fi
  chmod +x nknd; chmod +x nknc
  cp nknd nknc ../$DOCKER_NAME
  $START_COM
fi
   docker top $DOCKER_NAME | grep nknd
   if [ $? -ne 0 ]; then $START_COM ; fi
done 
cd $CURRENTDIR
