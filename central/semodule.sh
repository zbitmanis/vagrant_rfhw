 185  checkmodule -M -m -o  zabbix_sudo.mod zabbix_sudo.te 
  186  semodule_package -o zabbix_sudo.pp -m zabbix_sudo.mod 
  187  semodule -i zabbix_sudo.pp 
