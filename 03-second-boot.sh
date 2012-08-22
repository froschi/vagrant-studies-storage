#!/bin/bash

for disk in b c d e f; do
  sfdisk /dev/sd${disk} <<EOF
,,fd
EOF
done

sleep 5

mdadm --create /dev/md0 --level=10 --raid-devices=4 --spare-devices=1 /dev/sd[b-f]1

while true; do
  fgrep "resync" /proc/mdstat >/dev/null
  if [ "$?" -eq "0" ]; then
    echo "[+] Waiting for resync to finish. Sleeping 20 seconds."
    sleep 20
  else
    echo "[+] Resync done."
    break
  fi
done

mdadm --examine --scan >> /etc/mdadm/mdadm.conf
update-initramfs -u

# Initialize DRBD meta data
drbdadm create-md r0

# We want this reboot, because we have changed the kernel above.
reboot

#pvcreate /dev/md0
#vgcreate data /dev/md0
#lvcreate -n test --size 1G data
