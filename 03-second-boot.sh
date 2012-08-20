#!/bin/bash

for disk in b c d e f; do
  sfdisk /dev/sd${disk} <<EOF
,,fd
EOF
done

sleep 5

mdadm --create /dev/md0 --level=10 --raid-devices=4 --spare-devices=1 /dev/sd[b-f]1

# TODO: Find a way to reliably wait for completion. Might grep /proc/mdstat
# in a loop. The term to look for is 'resync'.

mdadm --examine --scan >> /etc/mdadm/mdadm.conf

pvcreate /dev/md0
vgcreate data /dev/md0
lvcreate -n test --size 1G data
