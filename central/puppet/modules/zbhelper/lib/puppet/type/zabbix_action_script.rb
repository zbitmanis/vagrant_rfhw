Puppet::Type.newtype(:zabbix_action_script) do
  @doc = 'Manage zabbix actions through zabbix api. '

  ensurable

  newparam(:name, namevar: true) do
    desc 'Action name'
  end
  
  newparam(:trigger_filter) do
    desc 'Filter for trigger content'
  end

  newparam(:command) do
    desc 'Script'
    isrequired
  end
  
  newparam(:zabbix_url) do
    desc 'Zabbix-api url'
    isrequired
  end
  newparam(:zabbix_user) do
    desc 'Zabbix-api user'
    isrequired
  end
  newparam(:zabbix_pass) do
    desc 'Zabbix-api  password'
    isrequired
  end
 
end 
