# Description

This Vagrant setup is part of a series of VMs designed to simulate an 'enterprise'-style infrastructure.

Here, we create a pair of VMs, turning them into a redundant storage server. You'll get a pair of redundant storage machines, based on Ubuntu 12.04LTS. Each of the machines comes with a stack of virtual SAS hard drives, in a RAID10 setup. The RAID is integrated into a DRBD mirrored block device.

## Where did NFS, iSCSI, ... go?

Initially, I wanted to implement the entire thing on top of this VM, including pacemaker for failover, as well as NFS and iSCSI. My plans are still to integrate these things in the future; however, for now I will use this setup here as a building block, whilst I implement corosync, pacemaker etc in separate setups.

The main reason for this approach is that in the end, I want to have reusable and re-pluggable chef cookbooks.

# Overview

This is just an overview. See the next section for step-by-step instructions.

This setup is different to my others in that you'll actually need to do some additional work to get it up and running. We can blame this on Vagrant. The additional hard drives can only be added to the VM as soon as VirtualBox knows about it. However, Vagrant immediately boots a VM at creation (`vagrant up`) time. So what you will have to do is:

1. Create the VMs using `vagrant up`. The names of the VMs will be `storage1` and `storage2`. The provisioning will run, installing `mdadm` and `drbd`, amongst other things.
1. Shut down the VMs. This is annoying, but VirtualBox before version 4.1 does not know about HD hotplugging, so we must attach the disks when the VMs are turned off.
1. Create and attach the virtual hard disks. Again, there is a script which will do the heavy lifting for you.
1. Boot the machines again. Now you'll need to run another set of commands to create the RAID arrays and such. This will again be done by a script. This script will also _reboot the machine once more_. Rationale see below.

After that, you can log into one of the VMs, promote its DRBD resource to _primary_, sync the resource between the hosts, and you are good to go.

# Detailed instructions

Time to get your hands dirty. First, clone the repo and `cd` into it. Take a look at the `Vagrantfile` to see if you want to adjust anything - this most likely applies to the box which you want to use. Then, bring up the machines:

    repo: $ vagrant up storage1 storage2

This will take a few minutes. Afterwards, shut down the machines again:

    repo: $ vagrant halt storage1 storage2

Run the script that creates the hard disk controllers and hard disks, and attaches them to  the VMs:

    repo: $ ./02-inbetween-boots.sh

This step will create a sub-directory named `disks/`. It will contain ten HD images, five for each VM, to be assembled into a four-disk RAID10, with an added spare disk. We are using sparse images here, in order not to completely siphon away all of the precious storage space on your host machine.

This process should be very quick. Bring up the VMs again and run:

    repo: $ vagrant ssh storage1 -c '/vagrant/03-second-boot.sh'
    repo: $ vagrant ssh storage2 -c '/vagrant/03-second-boot.sh'

This will use the `mdadm` tool to assemble the RAID array. The script waits for the RAIDs to sync, and create a DRDB volume label. It will then write the RAID configuration to `/etc/mdadm/mdadm.conf`, and update the system's initramfs. This is the step which also makes it necessary to reboot the machine again; after all, you want to run the kernel setup that you have configured to run.

## Setting up DRBD

When both nodes are coming up after a reboot, the two DRBD daemons connect to each other, but neither is authoritatve for any of the data that is supposed to be synced. To promote one of the nodes to _primary_ status and to force an initial synchronisation of the data from that node to the other, log into the node that is supposed to be primary and run the following:

    $ drbdadm -- --overwrite-data-of-peer primary r0

You can watch the progress of the sync by looking at `/proc/dbrd`. After that, you can start working with the partition.

# What's with the custom plugin and provisioner?

Nothing. They are there and get executed, but they are not doing anything useful at the moment. I am playing with them to see whether I can plug the hard disk creation into the process more conveniently. On the upside, they are not using up any resources, so there is nothing bad about them running.

# Roadmap, Todo

* Amend cookbooks. They do not contain my name, my email, or a correct license.
* The creation of the SAS controller and its attached hard disks could be plugged somewhere into Vagrant's middleware; that way, it might be possible to have the disks available before booting, making the reboot unnecessary.
* If the previous works, the remainder of the setup could be performed via shell-based provisioning. Even better! We write our own provisioner and sitcl stuff into the prepare method.
* We could get rid of setting the VMs name, too; note that Vagrant stores the UUIDs in `.vagrant`.
* Tests?

# Links & References

* DRBD:  http://www.drbd.org/
* Vagrant: http://www.vagrantup.com/
