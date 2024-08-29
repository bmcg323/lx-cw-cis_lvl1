#
# Cookbook:: lx-cw-cis_lvl1
# Recipe:: aide
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# 1.3.1 Ensure aide is installed
# package 'Install aide' do
#   package_name 'aide'
#   action :install
# end
package 'aide' unless node['packages']['aide']

bash 'initialize aide' do
  code <<-EOH
    aide --init
    mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
    EOH
  not_if { ::File.exist?('/var/lib/aide/aide.db.gz') }
end 
# 1.3.2 Ensure filesystem integrity is regularly checked
#  replace_or_add "Ensure filesystem integrity is regularly checked" do
#    path '/etc/crontab'
#    pattern 'aide --check'
#    line '05 3 * * * root /usr/sbin/aide --check'
#  end
aide_svc_files = %w ( aidecheck.service aidecheck.timer )

aide_svc_files.each do |file|
  cookbook_file "/etc/systemd/system/#{file}" do
    source "#{file}"
    mode '0644'
    owner 'root'
    group 'root'
  end
end

bash 'enable aide' do
  code <<-EOH
    systemctl daemon-reload
    systemctl enable aidecheck.service
    systemctl --now enable aidecheck.timer
    EOH
  not_if { ::File.exist?('/etc/systemd/system/multi-user.target.wants/aidecheck.timer') }
end