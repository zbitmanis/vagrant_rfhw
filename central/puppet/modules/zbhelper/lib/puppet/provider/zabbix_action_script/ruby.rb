require 'zabbixapi'

Puppet::Type.type(:zabbix_action_script).provide(:ruby) do
  
  def connect

    @zbx ||= create_connection(@resource[:zabbix_url], @resource[:zabbix_user], @resource[:zabbix_pass])
    @zbx
  end

  def create_connection(zabbix_url, zabbix_user, zabbix_pass)
    protocol =  'http'
    zbx = ZabbixApi.connect(
      url: "#{protocol}://#{zabbix_url}/api_jsonrpc.php",
      user: zabbix_user,
      password: zabbix_pass
    )
    zbx
  end


  def create
    if !exists?	
    zbx = connect
    zbx.actions.create(
	  :name =>  @resource[:name],
	  :eventsource => '0',                    # event source is a triggerid
	  :status => '0',                         # action is enabled
	  :esc_period => '60',                   # how long each step should take
	  :def_shortdata => "Email header",
	  :def_longdata => "Email content",
	  :maintenance_mode => '1',
	  :filter => {
	      :evaltype => '1',                   # perform 'and' between the conditions
	      :conditions => [
		  {
		      :conditiontype => '3',      # trigger name
		      :operator => '2',           # like
		      :value => @resource[:trigger_filter],         # the pattern
		  }
	      ]
	  },
	  :operations => [
	      {
		  :operationtype => '1',
		  :esc_period => '60',            
		  :esc_step_from => '1',            
		  :esc_step_to => '5',            
		  :opcommand => {
		      :type => '0',            # use default message
		      :execute_on =>  '0',            # email id
		      :command =>  @resource[:command] , 
		  },
                      :opcommand_hst => [{
			      :hostid=> 0
   		    }],
	      }
	  ],
	)
     end
  end

  def action_id
    zbx = connect
    @action_id ||= zbx.actions.get_id(name: @resource[:name])

  end

  def exists?
    zbx = connect
    zbx.actions.get_id(name: @resource[:name])
  end

  def destroy
    zbx = connect
    begin
      zbx.actions.delete(action_id)
    rescue => error
      raise(Puppet::Error, "Zabbix Action Delete Failed\n#{error.message}")
    end
  end
end

