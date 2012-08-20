#!/bin/bash

for disk in b c d e; do
  sfdisk /dev/sd${disk} <<EOF
,,fd
EOF
done

sleep 5

mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/sd[b-e]1

# TODO: Find a way to reliably wait for completion. Might grep /proc/mdstat
# in a loop.

pvcreate /dev/md0
vgcreate data /dev/md0
lvcreate -n test --size 1G data
