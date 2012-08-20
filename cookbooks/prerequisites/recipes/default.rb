#
# Cookbook Name:: prerequisites
# Recipe:: default
#
# Copyright (C) 2012 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
execute "apt-get-update" do
  command "apt-get update"
  action :run
  not_if do
    File.exists?("/tmp/.aptrun")
  end
end

file "tmp-aptrun" do
  action :create
  path "/tmp/.aptrun"
end

package "vim-nox"
package "msmtp-mta" # Lest mdadm installs postfix.
package "mdadm"
