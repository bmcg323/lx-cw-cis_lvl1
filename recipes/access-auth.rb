#
# Cookbook:: lx-cw-cis_lvl1
# Recipe:: access-auth
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# 4 Access, Authentication and Authorization

# 4.1.1 Ensure cron daemon is installed and enabled
service 'crond' do
  action [ :enable, :start ]
  only_if { node['packages']['cronie'] }
end

# 4.1.2 Ensure permissions on /etc/crontab are configured
file '/etc/crontab' do
  owner 'root'
  group 'root'
  mode '0600'
  only_if { node['packages']['cronie'] }
end

# 4.1.3 Ensure permissions on /etc/cron.hourly are configured
directory '/etc/cron.hourly' do
  owner 'root'
  group 'root'
  mode '0700'
  only_if { node['packages']['cronie'] }
end

# 4.1.4 Ensure permissions on /etc/cron.daily are configured
directory '/etc/cron.daily' do
  owner 'root'
  group 'root'
  mode '0700'
  only_if { node['packages']['cronie'] }
end

# 4.1.5 Ensure permissions on /etc/cron.weekly are configured
directory '/etc/cron.weekly' do
  owner 'root'
  group 'root'
  mode '0700'
  only_if { node['packages']['cronie'] }
end

# 4.1.6 Ensure permissions on /etc/cron.monthly are configured
directory '/etc/cron.monthly' do
  owner 'root'
  group 'root'
  mode '0700'
  only_if { node['packages']['cronie'] }
end

# 4.1.7 Ensure permissions on /etc/cron.d are configured
directory '/etc/cron.d' do
  owner 'root'
  group 'root'
  mode '0700'
  only_if { node['packages']['cronie'] }
end

# 4.1.8 Ensure cron is restricted to authorized users
file '/etc/cron.deny' do
  action :delete
  only_if { node['packages']['cronie'] }
end

file '/etc/cron.allow' do
  owner 'root'
  group 'root'
  mode '0600'
  only_if { node['packages']['cronie'] }
end

# 4.1.9 Ensure at is restricted to authorized users 
file '/etc/at.deny' do
  action :delete
  only_if { node['packages']['at'] }
end

file '/etc/at.allow' do
  owner 'root'
  group 'root'
  mode '0600'
  only_if { node['packages']['at'] }
end

# 4.2 Configure SSH Server
## Excluded settings:
## 4.2.4 Ensure SSH access is limited
## 4.2.12 Ensure SSH X11 forwarding is disabled # lvl 2 setting
## 4.2.13 Ensure SSH AllowTcpForwarding is disabled # lvl2 setting
## 4.2.14 Ensure system-wide crypto policy is not over-ridden

# 4.2.1 Ensure permissions on /etc/ssh/sshd_config are configured
file '/etc/ssh/sshd_config' do
  owner 'root'
  group 'root'
  mode '0600'
end

# 4.2.2 Ensure permissions on SSH private host key files are configured
priv_keys = `ls /etc/ssh | grep key | grep -v .pub`.split.to_a
priv_keys.each do |key|
  file "#{key}" do
    owner 'root'
    group 'ssh_keys'
    mode '0640'
  end
end

# 4.2.3 Ensure permissions on SSH public host key files are configured
pub_keys = `ls /etc/ssh | grep .pub`.split.to_a
pub_keys.each do |key|
  file "#{key}" do
    owner 'root'
    group 'root'
    mode '0644'
  end
end

# 4.2.5 Ensure SSH LogLevel is appropriate
# 4.2.6 Ensure SSH PAM is enabled
# 4.2.7 Ensure SSH root login is disabled
# 4.2.8 Ensure SSH HostbasedAuthentication is disabled
# 4.2.9 Ensure SSH PermitEmptyPasswords is disabled
# 4.2.10 Ensure SSH PermitUserEnvironment is disabled
# 4.2.11 Ensure SSH IgnoreRhosts is enabled
# 4.2.15 Ensure SSH warning banner is configured
# 4.2.16 Ensure SSH MaxAuthTries is set to 4 or less
# 4.2.17 Ensure SSH MaxStartups is configured
# 4.2.18 Ensure SSH MaxSessions is set to 10 or less
# 4.2.19 Ensure SSH LoginGraceTime is set to one minute or less
# 4.2.20 Ensure SSH Idle Timeout Interval is configured
cookbook_file '/etc/ssh/sshd_config.d/99-cis.conf' do
  source 'sshd.d_99-cis.conf'
  mode '0600'
  owner 'root'
  group 'root'
  verify '/usr/sbin/sshd -t'
end

# 4.3 Configure privilege escalation
## Excluded settings:
## 4.3.4 Ensure re-authentication for privilege escalation is not disabled globally 

# 4.3.1 Ensure sudo is installed
package 'sudo' unless node['packages']['sudo']

# 4.3.2 Ensure sudo commands use pty
# 4.3.3 Ensure sudo log file exists
# 4.3.5 Ensure sudo authentication timeout is configured correctly
cookbook_file '/etc/sudoers.d/99-cis_sudo' do
  source '99-cis_sudo'
  mode '0440'
  owner 'root'
  group 'root'
  verify 'visudo -c -f %{path}'
end

cookbook_file '/etc/logrotate.d/sudo-log' do
  source 'sudo-log'
  mode '0644'
  owner 'root'
  group 'root'
end

# 4.3.6 Ensure access to the su command is restricted
file '/etc/pam.d/su' do
  mode '0644'
  owner 'root'
  group 'root'
end

group 'sugroup' do
  comment 'empty group to restrict su'
  gid 2000
  not_if 'grep 2000 /etc/group'
end

replace_or_add 'Restrict su Command' do
  path '/etc/pam.d/su'
  pattern '.*pam_wheel.so use_uid'
  line 'auth            required        pam_wheel.so use_uid group=sugroup'
end

# 4.4 Configure authselect
### WARNING:
###  Do not use authselect if:
###  • Your host is part of Active Directory via SSSD. Calling the realm join command to
###    join your host to an Active Directory domain automatically configures SSSD
###    authentication on your host.
## Excluded settings:
## 4.4.1 Ensure custom authselect profile is used
## 4.4.2 Ensure authselect includes with-faillock

# 4.5 Configure PAM
### Skipped due to AD auth
## Excluded settings:
## 4.5.1 Ensure password creation requirements are configured
## 4.5.2 Ensure lockout for failed password attempts is configured
## 4.5.3 Ensure password reuse is limited
## 4.5.4 Ensure password hashing algorithm is SHA-512

# 4.6 User Accounts and Environment
## Excluded settings:
## 4.6.1 Set Shadow Password Suite Parameters
## 4.6.2 Ensure system accounts are secured
## 4.6.6 Ensure root password is set

# 4.6.3 Ensure default user shell timeout is 900 seconds or less
cookbook_file '/etc/profile.d/cis_lvl1.sh' do
  source 'cis_lvl1'
  mode '0644'
  owner 'root'
  group 'root'
end

# 4.6.4 Ensure default group for the root account is GID 0
# 4.6.5 Ensure default user umask is 027 or more restrictive
user 'root' do
  gid 0
  not_if 'id root | grep -q gid=0'
end

replace_or_add 'default umask for /etc/bashrc' do
  path '/etc/bashrc'
  pattern '^\s*umask\s'
  line '    umask 027'
end