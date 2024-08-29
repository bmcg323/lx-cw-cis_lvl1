#
# Cookbook:: lx-cw-cis_lvl1
# Recipe:: network-config
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# 3 Network Configuration

# 3.1 Disable unused network protocols and devices
## Excluded settings:
## 3.1.1_Ensure_IPv6_status_is_identified

## IPV6 here settings here if determined it is needed

# 3.1.2_Ensure_DCCP_is_disabled
# 3.1.3_Ensure_SCTP_is_disabled
# 3.1.4_Ensure_RDS_is_disabled
# 3.1.5_Ensure_TIPC_is_disabled

modules = %w( dccp sctp rds tipc )

modules.each do |mod|
  execute "rmmod #{mod}" do
    only_if "lsmod | grep #{mod}"
  end

  file "blacklist #{mod}" do
    path "/etc/modprobe.d/#{mod}.conf"
    content "install #{mod} /bin/false\nblacklist #{mod}\n"
  end
end

# 3.2 Configure Network Parameters (Host Only)

# 3.2.1 Ensure IP forwarding is disabled
sysctl 'net.ipv4.ip_forward' do
  value 0
  not_if { ::File.exist?('/usr/bin/docker') }
  not_if { ::File.exist?('/usr/bin/kubelet') }
end

sysctl 'net.ipv6.conf.all.forwarding' do
  value 0
  only_if 'sysctl net.ipv6.conf.all.disable_ipv6 | grep -q 0'
end

# 3.2.2 Ensure packet redirect sending is disabled
sysctl 'net.ipv4.conf.all.send_redirects' do
  value 0
end

sysctl 'net.ipv4.conf.default.send_redirects' do
  value 0
end

# 3.3 Configure Network Parameters (Host and Router)

# 3.3.1 Ensure source routed packets are not accepted
sysctl 'net.ipv4.conf.all.accept_source_route' do
  value 0
end

sysctl 'net.ipv4.conf.default.accept_source_route' do
  value 0
end

sysctl 'net.ipv6.conf.all.accept_source_route' do
  value 0
  only_if 'sysctl net.ipv6.conf.all.disable_ipv6 | grep -q 0'
end

sysctl 'net.ipv6.conf.default.accept_source_route' do
  value 0
  only_if 'sysctl net.ipv6.conf.all.disable_ipv6 | grep -q 0'
end

# 3.3.2 Ensure ICMP redirects are not accepted
sysctl 'net.ipv4.conf.all.accept_redirects' do
  value 0
end

sysctl 'net.ipv4.conf.default.accept_redirects' do
  value 0
end

sysctl 'net.ipv6.conf.all.accept_redirects' do
  value 0
  only_if 'sysctl net.ipv6.conf.all.disable_ipv6 | grep -q 0'
end

sysctl 'net.ipv6.conf.default.accept_redirects' do
  value 0
  only_if 'sysctl net.ipv6.conf.all.disable_ipv6 | grep -q 0'
end

# 3.3.3 Ensure secure ICMP redirects are not accepted
sysctl 'net.ipv4.conf.all.secure_redirects' do
  value 0
end

sysctl 'net.ipv4.conf.default.secure_redirects' do
  value 0
end

# 3.3.4 Ensure suspicious packets are logged
sysctl 'net.ipv4.conf.all.log_martians' do
  value 1
end

sysctl 'net.ipv4.conf.default.log_martians' do
  value 1
end

# 3.3.5 Ensure broadcast ICMP requests are ignored
sysctl 'net.ipv4.icmp_echo_ignore_broadcasts' do
  value 1
end

# 3.3.6 Ensure bogus ICMP responses are ignored
sysctl 'net.ipv4.icmp_ignore_bogus_error_responses' do
  value 1
end

# 3.3.7 Ensure Reverse Path Filtering is enabled
sysctl 'net.ipv4.conf.all.rp_filter' do
  value 1
end

sysctl 'net.ipv4.conf.default.rp_filter' do
  value 1
end

# 3.3.8 Ensure TCP SYN Cookies is enabled
sysctl 'net.ipv4.tcp_syncookies' do
  value 1
end

# 3.3.9 Ensure IPv6 router advertisements are not accepted
sysctl 'net.ipv6.conf.all.accept_ra' do
  value 0
  only_if 'sysctl net.ipv6.conf.all.disable_ipv6 | grep -q 0'
end

sysctl 'net.ipv6.conf.default.accept_ra' do
  value 0
  only_if 'sysctl net.ipv6.conf.all.disable_ipv6 | grep -q 0'
end

## 3.4 Configure Host Based Firewall (level2 settings)
## Excluded settings:
## entire section skipped 