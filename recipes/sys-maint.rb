#
# Cookbook:: lx-cw-cis_lvl1
# Recipe:: sys-maint
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# 6 System Maintenance

# 6.1 System File Permissions
## Excluded settings:
## 6.1.10 Audit system file permissions # lvl 2 setting
## 6.1.11 Ensure world writable files and directories are secured
## 6.1.12 Ensure no unowned or ungrouped files or directories exist
## 6.1.13 Ensure SUID and SGID files are reviewed

# 6.1.1 Ensure permissions on /etc/passwd are configured
# 6.1.2 Ensure permissions on /etc/passwd are configured
file '/etc/passwd' do
  owner 'root'
  group 'root'
  mode '0644'
end

# 6.1.3 Ensure permissions on /etc/passwd- are configured
file '/etc/passwd-' do
  owner 'root'
  group 'root'
  mode '0644'
end

# 6.1.4 Ensure permissions on /etc/group are configured
file '/etc/group' do
  owner 'root'
  group 'root'
  mode '0644'
end

# 6.1.5 Ensure permissions on /etc/group- are configured
file '/etc/group-' do
  owner 'root'
  group 'root'
  mode '0644'
end

# 6.1.6 Ensure permissions on /etc/shadow are configured
file '/etc/shadow' do
  owner 'root'
  group 'root'
  mode '0000'
end

# 6.1.7 Ensure permissions on /etc/shadow- are configured
file '/etc/shadow-' do
  owner 'root'
  group 'root'
  mode '0000'
end

# 6.1.8 Ensure permissions on /etc/gshadow are configured
file '/etc/gshadow' do
  owner 'root'
  group 'root'
  mode '0000'
end

# 6.1.9 Ensure permissions on /etc/gshadow- are configured
file '/etc/gshadow-' do
  owner 'root'
  group 'root'
  mode '0000'
end

# 6.2 Local User and Group Settings
## Excluded settings:
## section skipped due to manual interventions required