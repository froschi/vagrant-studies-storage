class HDProvisioner < Vagrant::Provisioners::Base
  def prepare
    #env[:vm].config.vm.share_folder("foo-folder", "/tmp/foo-provisioning",
    #                                              "/path/to/host/folder")
    @env[:ui].info "This is output from a provisioner prepare method."
  end
end


