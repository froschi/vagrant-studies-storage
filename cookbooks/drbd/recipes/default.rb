#
# Cookbook Name:: drbd
# Recipe:: default
#
# Copyright (C) 2012 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

package "drbd8-utils"

execute "drbd-restart" do
  command "/etc/init.d/drbd restart"
  action :nothing
  only_if do
    File.exists?('/dev/md0')
  end
end

cookbook_file "/etc/drbd.d/global_common.conf" do
  source "global_common.conf"
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :run, "execute[drbd-restart]"
end

cookbook_file "/etc/drbd.conf" do
  source "drbd.conf"
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :run, "execute[drbd-restart]"
end
