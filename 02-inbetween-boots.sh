#!/bin/bash

mkdir -p disks

for s in 1 2; do
  VBoxManage storagectl storage${s} --name "SAS Controller" --add sas --controller LSILogicSAS
  for d in 1 2 3 4; do
    imgfile="disks/storage${s}${d}.vdi"
    if [ ! -f $imgfile ]; then
      VBoxManage createhd --filename $imgfile --size 10240 --format VDI --variant Standard
      VBoxManage storageattach storage${s} --storagectl "SAS Controller" --port ${d} --device 0 --type hdd --medium $imgfile
    fi
  done
done

