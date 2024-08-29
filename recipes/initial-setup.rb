#
# Cookbook:: lx-cw-cis_lvl1
# Recipe:: initial-setup
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# 1 Initial Setup

# 1.1 Filesystem Configuration
## Excluded settings:
## 1.1.2.1_Ensure_/tmp_is_a_separate_partition
## 1.1.3 Configure /var
## 1.1.4 Configure /var/tmp
## 1.1.5 Configure /var/log
## 1.1.6 Configure /var/log/audit
## 1.1.7 Configure /home
## 1.1.8.1 Ensure /dev/shm is a separate partition
## 1.1.9 Ensure usb-storage is disabled

# 1.1.1.1_Ensure_mounting_of_squashfs_filesystems_is_disabled
# 1.1.1.2_Ensure_mounting_of_udf_filesystems_is_disabled
# 1.1.1.3_Ensure_mounting_of_cramfs_filesystems_is_disabled
# 1.1.1.4_Ensure_mounting_of_freevxfs_filesystems_is_disabled
# 1.1.1.5_Ensure_mounting_of_jffs2_filesystems_is_disabled
# 1.1.1.6_Ensure_mounting_of_hfs_filesystems_is_disabled
# 1.1.1.7_Ensure_mounting_of_hfsplus_filesystems_is_disabled
modules = %w( squashfs udf cramfs freevxfs jffs2 hfs hfsplus )

modules.each do |mod|
  execute "rmmod #{mod}" do
    only_if "lsmod | grep #{mod}"
  end

  file "blacklist #{mod}" do
    path "/etc/modprobe.d/#{mod}.conf"
    content "install #{mod} /bin/true"
  end
end

# 1.1.2.2 Ensure_nodev_option_set_on_/tmp_partition
# 1.1.2.3 Ensure noexec option set on /tmp partition
# 1.1.2.4 Ensure nosuid option set on /tmp partition
execute 'mount -o remount,nosuid,nodev,noexec /tmp' do
  only_if 'mount | grep /tmp'
  not_if 'mount | grep /tmp | grep nosuid,nodev,noexec'
end

# 1.1.8.2 Ensure nodev option set on /dev/shm partition
# 1.1.8.3 Ensure noexec option set on /dev/shm partition
# 1.1.8.4 Ensure nosuid option set on /dev/shm partition
execute 'mount -o remount,nosuid,nodev,noexec /dev/shm' do
  only_if 'mount | grep /dev/shm'
  not_if 'mount | grep /dev/shm | grep nosuid,nodev,noexec'
end

# 1.2 Configure Software and Patch Management
## Excluded settings:
## entire section skipped 

# 1.3 Filesystem Integrity Checking
## Excluded settings:
## entire section skipped 
# include_recipe 'lx-cw-cis_lvl1::aide' # uncomment to install/enable aide

# 1.4 Secure Boot Settings
## Excluded settings:
## entire section skipped

# 1.5 Additional Process Hardening

# 1.5.1 Ensure address space layout randomization (ASLR) is enabled
# 1.5.2 Ensure ptrace_scope is restricted
execute 'kernel.randomize_va_space' do
  command '/sbin/sysctl -w kernel.randomize_va_space=2'
  not_if '/sbin/sysctl -q -n kernel.randomize_va_space | /usr/bin/grep 2'
end

execute 'kernel.yama.ptrace_scope' do
  command '/sbin/sysctl -w kernel.yama.ptrace_scope=1'
  not_if '/sbin/sysctl -q -n kernel.yama.ptrace_scope | /usr/bin/grep 1'
end

cookbook_file '/etc/sysctl.d/60-kernel_sysctl.conf' do
  source '60-kernel_sysctl.conf'
  mode '0644'
  owner 'root'
  group 'root'
end

# 1.5.3 Ensure core dump storage is disabled
replace_or_add "disable core dump storage" do
  path "/etc/systemd/coredump.conf"
  pattern "Storage="
  line "Storage=none"
end

# 1.5.4 Ensure core dump backtraces are disabled
replace_or_add "disable core dump backtraces" do
  path "/etc/systemd/coredump.conf"
  pattern "ProcessSizeMax="
  line "ProcessSizeMax=0"
end

# 1.6 Mandatory Access Control
## Excluded settings:
## 1.6.1 Configure SELinux
## 1.6.1.1 Ensure SELinux is installed
## 1.6.1.2 Ensure SELinux is not disabled in bootloader configuration
## 1.6.1.3 Ensure SELinux policy is configured
## 1.6.1.4 Ensure the SELinux mode is not disabled
## 1.6.1.5 Ensure the SELinux mode is enforcing
## 1.6.1.6 Ensure no unconfined services exist
## 1.6.1.7 Ensure SETroubleshoot is not installed
## 1.6.1.8 Ensure the MCS Translation Service (mcstrans) is not installed
 
# 1.7 Command Line Warning Banners
## Excluded settings:
## 1.7.1 Ensure message of the day is configured properly


# 1.7.2 Ensure local login warning banner is configured properly
# 1.7.5 Ensure permissions on /etc/issue are configured
cookbook_file '/etc/issue' do
  source 'etc_issue'
  mode '0644'
  owner 'root'
  group 'root'
end

# 1.7.3 Ensure remote login warning banner is configured properly
# 1.7.6 Ensure permissions on /etc/issue.net are configured
cookbook_file '/etc/issue.net' do
  source 'etc_issue'
  mode '0644'
  owner 'root'
  group 'root'
end

# 1.7.4 Ensure permissions on /etc/motd are configured
file '/etc/motd' do
  mode '0644'
  owner 'root'
  group 'root'
  manage_symlink_source true
end

# 1.8 Ensure updates, patches, and additional security software are installed
## Excluded settings:
## entire section skipped

# 1.9 Ensure system-wide crypto policy is not legacy
execute 'set crypto policy' do
  command 'update-crypto-policies --set DEFAULT'
  only_if 'grep -i ^LEGACY /etc/crypto-policies/config'
end