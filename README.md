# Description

This Vagrant setup is part of a series of VMs simulating an 'enterprise'-style infrastructure. It creates a pair of VMs simulating a storage server. It is based on Ubuntu, using the precise64 base box.

What you'll get:

* A pair of redundant storage machines.
* Redundancy is managed over DRBD and heartbeat.
* The machines serves chunks of storage toward the hostonly network over iSCSI and NFS.

Each of the machines comes with four virtual 10GB SAS hard drives, in a RAID10 setup.

# Details

This machine is unique in that you'll actually need to do some additional work to get it up and running. We can blame this on Vagrant. The additional hard drives can only be added to the VM as soon as VirtualBox knows about it. However, Vagrant immediately boots a VM at creation (`vagrant up`) time. So what you will have to do is:

1. Create the VMs using `vagrant up`.
1. If you are using a vanilla precise64 base box, you'll have to install the `mdadm` tools, which are not included by default. There is a script here which will do that for you.
1. Shut down the VMs. This is annoying, but VirtualBox before version 4.1 does not know about HD hotplugging, so we must attach them when the VMs are turned off.
1. Create and attach the virtual hard disks. Again, there is a script which will do the heavy lifting for you.
1. Boot the machines again. Now you'll need to run another set of commands (read: script again) to create the RAID arrays, LVM volumes etc.
1. Then, the chef cookbooks will do the rest for you.

# Links & References

* DRBD: 
* Vagrant: 
