Vagrant::Config.run do |config|

  config.vm.define :storage1 do |s1|
    # Some memory and cores
    s1.vm.customize ["modifyvm", :id, "--memory", 256]
    s1.vm.customize ["modifyvm", :id, "--cpus", 1]
    s1.vm.customize ["modifyvm", :id, "--name", "storage1"]

    # Disable vbguest; manage by hand, if at all
    s1.vbguest.auto_update = false
    s1.vbguest.no_remote = true

    # Networking, in addition to the bridged interface
    s1.vm.network :hostonly, "192.168.1.10"

    s1.vm.box = "storage1"
    s1.vm.host_name = "storage1"
    s1.vm.box_url = "/home/thorsten/.vagrant.d/boxes/froschi-precise64-base.box"
  end

  config.vm.define :storage2 do |s2|
    # Some memory and cores
    s2.vm.customize ["modifyvm", :id, "--memory", 256]
    s2.vm.customize ["modifyvm", :id, "--cpus", 1]
    s2.vm.customize ["modifyvm", :id, "--name", "storage2"]

    # Disable vbguest; manage by hand, if at all
    s2.vbguest.auto_update = false
    s2.vbguest.no_remote = true

    # Networking, in addition to the bridged interface
    s2.vm.network :hostonly, "192.168.1.11"

    s2.vm.box = "storage2"
    s2.vm.host_name = "storage2"
    s2.vm.box_url = "/home/thorsten/.vagrant.d/boxes/froschi-precise64-base.box"
  end

end
