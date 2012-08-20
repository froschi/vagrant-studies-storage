# Description

This Vagrant setup is part of a series of VMs simulating an 'enterprise'-style infrastructure. It creates a pair of VMs simulating a storage server. It is based on Ubuntu, using the precise64 base box.

What you'll get:

* A pair of redundant storage machines.
* Redundancy is managed over DRBD and heartbeat.
* The machines serves chunks of storage toward the hostonly network over iSCSI and NFS.

Each of the machines comes with a stack of virtual SAS hard drives, in a RAID10 setup.

# Details

This is just an overview. See the next section for step-by-step instructions.

This machine is unique in that you'll actually need to do some additional work to get it up and running. We can blame this on Vagrant. The additional hard drives can only be added to the VM as soon as VirtualBox knows about it. However, Vagrant immediately boots a VM at creation (`vagrant up`) time. So what you will have to do is:

1. Create the VMs using `vagrant up`.
1. If you are using a vanilla precise64 base box, you'll have to install the `mdadm` tools, which are not included by default. There is a script here which will do that for you.
1. Shut down the VMs. This is annoying, but VirtualBox before version 4.1 does not know about HD hotplugging, so we must attach them when the VMs are turned off.
1. Create and attach the virtual hard disks. Again, there is a script which will do the heavy lifting for you.
1. Boot the machines again. Now you'll need to run another set of commands (read: script again) to create the RAID arrays, LVM volumes etc.
1. Then, the chef cookbooks will do the rest for you.

# Instructions

Time to get your hands dirty. First, clone the repo and `cd` into it. Take a look at the `Vagrantfile` to see if you want to adjust anything. Then, bring up the machines:

```
repo: $ vagrant up storage1 storage2
```

This will take a few minutes. Afterwards, SSH into each of the machines and run the first setup script:

```
storage: $ sudo /vagrant/01-first-boot.sh
```

Log out of both machines and shut them down. Then run the script that creates the hard disks for you:

```
repo: $ ./02-inbetween-boots.sh
```

This step will create a sub-directory named `disks/`. It will contain ten HD images, five for each VM. They will later be assembled into a four-disk RAID10, with an added spare disk. We are using sparse images here, in order not to completely siphon away all of the precious storage space on your host machine.

This process should be very quick. Bring up the VMs again, SSH into them again and run:

```
storage: $ sudo /vagrant/03-second-boot.sh
```

This will use the `mdadm` tool to assemble the array. The resulting array will then be turned into a physical volume for LVM. A volume group called `data` will be set up over the entirety of the physical volume. And you'll get a first logical volume in there to boost! It's called `test` and 1GB in size.

# Roadmap, Todo

* Use variables in the Vagrantfile. In fact, move everything into some JSON blocks for configuration.
* The creation of the SAS controller and its attached hard disks could be plugged somewhere into Vagrant's middleware; that way, it might be possible to have the disks available before booting, making the reboot unnecessary.
* If the previous works, the remainder of the setup could be performed via shell-based provisioning.
* We could get rid of setting the VMs name, too; note that Vagrant stores the UUIDs in `.vagrant`.
* Tests?
* Chef coobooks:
- DRBD
- iSCSI
- NFS

# Links & References

* DRBD: 
* Vagrant: 
