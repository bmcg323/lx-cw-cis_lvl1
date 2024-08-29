#
# Cookbook:: lx-cw-cis_lvl1
# Recipe:: logging-auditing
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# 5 Logging and Auditing

# 5.1 Configure Logging
## Excluded settings:
## 5.1.1 Configure rsyslog
## 5.1.2.1 Ensure journald is configured to send logs to a remote log host
## 5.1.2.1.4 Ensure journald is not configured to receive logs from a remote client
## 5.1.2.2 Ensure journald service is enabled
## 5.1.2.3 Ensure journald is configured to compress large log files
## 5.1.2.5 Ensure journald is not configured to send logs to rsyslog
## 5.1.2.6 Ensure journald log rotation is configured per site policy
## 5.1.2.7 Ensure journald default file permissions configured
## 5.1.3 Ensure all logfiles have appropriate permissions and ownership

# 5.1.2 Configure journald
# 5.1.2.4 Ensure journald is configured to write logfiles to persistent disk
systemd_unit 'systemd-journald.service' do
    action :nothing
end

execute 'journald_persistent_logs' do
  not_if 'grep ^\s*Storage /etc/systemd/journald.conf'
  command 'sed -i s/#Storage=auto/Storage=persistent/ /etc/systemd/journald.conf'
  notifies :restart, 'systemd_unit[systemd-journald.service]', :delayed
end

# 5.2 Configure System Accounting
## Entire section skipped due to being lvl 2

# 5.3 Ensure logrotate is configured
## Skipped due to being a manual check