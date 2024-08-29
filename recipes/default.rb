#
# Cookbook:: lx-cw-cis_lvl1
# Recipe:: default
#
# Copyright:: 2024, The Authors, All Rights Reserved.

include_recipe 'lx-cw-cis_lvl1::initial-setup'
include_recipe 'lx-cw-cis_lvl1::services'
include_recipe 'lx-cw-cis_lvl1::network-config'
include_recipe 'lx-cw-cis_lvl1::access-auth'
include_recipe 'lx-cw-cis_lvl1::logging-auditing'
include_recipe 'lx-cw-cis_lvl1::sys-maint'

# create Asurion standard /opt/tmp dir
directory '/opt/tmp' do
  owner 'root'
  group 'root'
  mode '1777'
end

# Create /etc/Asurion and set mode
directory '/etc/Asurion' do
  owner 'root'
  group 'root'
  mode '0755'
end

template '/etc/Asurion/CIS_hardening_status' do
  source 'CIS_hardening_status.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(cver: IO.readlines(File.join(File.dirname(__FILE__), '../metadata.rb'))[5].split[1].delete("'"))
end

