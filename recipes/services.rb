#
# Cookbook:: lx-cw-cis_lvl1
# Recipe:: services
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# 2 Services

# 2.1 Configure Time Synchronization

# 2.1.1 Ensure time synchronization is in use
package 'chrony' unless node['packages']['chrony']

# 2.1.2 Ensure chrony is configured
service 'chronyd' do
  action [ :enable, :start ]
end

# 2.2 Configure Special Purpose Services
## Excluded settings:
## 2.2.1 Ensure xorg-x11-server-common is not installed
## 2.2.8 Ensure a web server is not installed
## 2.2.15 Ensure mail transfer agent is configured for local-only mode
## 2.2.16 Ensure nfs-utils is not installed or the nfs-server service is masked

# 2.2.2 Ensure avahi is not installed
# 2.2.3 Ensure a print server is not installed
# 2.2.4 Ensure a dhcp server is not installed
# 2.2.5 Ensure a dns server is not installed
# 2.2.6 Ensure an ftp server is not installed
# 2.2.7 Ensure a tftp server is not installed
# 2.2.9 Ensure IMAP and POP3 server is not installed
# 2.2.10 Ensure Samba is not installed
# 2.2.11 Ensure HTTP Proxy Server is not installed
# 2.2.12 Ensure net-snmp is not installed or the snmpd service is not enabled
# 2.2.13 Ensure telnet-server is not installed
# 2.2.14 Ensure dnsmasq is not installed
# 2.2.17 Ensure rpcbind is not installed or the rpcbind services are masked
# 2.2.18 Ensure rsync-daemon is not installed or the rsyncd service is masked
# 2.3 Service Clients
# 2.3.1 Ensure telnet client is not installed
# 2.3.2 Ensure LDAP client is not installed
# 2.3.3 Ensure FTP client is not installed

lvl1_pkgs = %w( avahi cups dhcp-server bind vsftpd tftp-server dovecot cyrus-imapd samba squid net-snmp telnet-server dnsmasq rsync-daemon telnet openldap-clients ftp )
lvl1_svcs = %w( avahi-daemon.socket avahi-daemon.service rpcbind.socket rpcbind.service rsyncd ) 
# lvl2_pkgs: 
# lvl2_svcs: xorg-x11-server-common 
# skipped_pkgs: httpd nginx nfs-utils
lvl1_svcs.each do |svc|
  service "#{svc}" do
    action [ :disable, :stop ]
  end
end

lvl1_pkgs.each do |pkg|
  package "#{pkg}" do
    action :purge
  end
end

# 2.4 Ensure nonessential services listening on the system are removed or masked
## Excluded settings:
## entire section skipped 
