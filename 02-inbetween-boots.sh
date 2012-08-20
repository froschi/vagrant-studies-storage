#!/bin/bash

DISK_SIZE=15360

mkdir -p disks

for s in 1 2; do
  VBoxManage storagectl storage${s} --name "SAS Controller" --add sas --controller LSILogicSAS
  for d in 1 2 3 4 5; do
    imgfile="disks/storage${s}${d}.vdi"
    if [ ! -f $imgfile ]; then
      echo "[+] Creating disk $imgfile"
      VBoxManage createhd --filename $imgfile --size $DISK_SIZE --format VDI --variant Standard
      VBoxManage storageattach storage${s} --storagectl "SAS Controller" --port ${d} --device 0 --type hdd --medium $imgfile
    fi
  done
done

