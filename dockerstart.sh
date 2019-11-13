#!/bin/bash


exec {DIR_LIST}<dir.list
exec {IP_LIST}<ip.list
exec {PASS_LIST}<pass.list

while read -r -u "$DIR_LIST" DIR_NAME  && read -r -u "$IP_LIST" IP_ADDR && read -r -u "$PASS_LIST" WPASSWORD
do
   sudo docker run -d -p 91.103.98.240:30001-30003:30001-30003 -v /home/nodemaster/nkn001:/nkn --name nkn001 -w /nkn --rm -it nknorg/nkn /nkn/nknd -p Xxx

done

