#!/bin/bash

sudo systemctl stop nkn.service
wget https://github.com/nknorg/nkn/releases/download/v1.1.2-beta.1/linux-amd64.zip
unzip linux-amd64.zip >/dev/null 2>&1
cp -r linux-amd64/nkn* nkn-node
cp -r linux-amd64/certs nkn-node
cp -r linux-amd64/web nkn-node
rm -rf linux-amd64 linux-amd64.zip nkn
rm -rf nkn-node/Log
sudo systemctl start nkn.service
