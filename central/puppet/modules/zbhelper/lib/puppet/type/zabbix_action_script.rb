Puppet::Type.newtype(:zabbix_action_script) do
  @doc = 'Manage zabbix actions.'

  ensurable

  newparam(:name, namevar: true) do
    desc 'Action name'
  end
  
  newproperty(:trigger_filter) do
    desc 'Filter for trigger content'
  end

  newproperty(:command) do
    desc 'Script'
    isrequired
  end
  
  newproperty(:zabbix_url) do
    desc 'Zabbix-api url'
    isrequired
  end
  newproperty(:zabbix_user) do
    desc 'Zabbix-api user'
    isrequired
  end
  newproperty(:zabbix_pass) do
    desc 'Zabbix-api  password'
    isrequired
  end
 
end 
