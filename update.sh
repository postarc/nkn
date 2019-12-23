#!/bin/bash

sudo systemctl stop nkn.service
wget https://github.com/nknorg/nkn/releases/download/v1.1.2-beta.1/linux-amd64.zip
unzip $FNAME >/dev/null 2>&1
mv linux-amd64/nkn* nkn-node/.
mv linux-amd64/certs nkn-node/.
mv linux-amd64/web nkn-node/.
rm -rf linux-amd64 linux-amd64.zip nkn

sudo systemctl start nkn.service
