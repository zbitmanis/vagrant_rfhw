node 'central' {
  class { 'apache':
    mpm_module => 'prefork',
    default_vhost => false,	
  }
  include apache::mod::php

  class { 'mysql::server': }

  class { 'zabbix':
    zabbix_url    => 'central',
    database_type => 'mysql',
	zabbix_timezone => 'Europe/Riga',
	default_vhost => true,
	zabbix_api_user =>  'capi',
	zabbix_api_pass => 'i6htnXdeWjex4z',
  }
   class { '::php':
    fpm => false,	
    settings   => {
      'PHP/max_execution_time'  => '90',
      'PHP/max_input_time'      => '300',
      'PHP/memory_limit'        => '64M',
      'PHP/post_max_size'       => '32M',
      'PHP/upload_max_filesize' => '32M',
      'Date/date.timezone'      => 'Europe/Riga',
    },
  }
  $myip=$::facts['networking']['ip']
  $myhost=$::facts['networking']['hostname']
  notify  {"MyIP is ${myip} ( ${facts['networking']['ip']}) MyHost ${myhost} ( ${facts['networking']['hostname']}  ": }
  class { 'zabbix::agent':
    server => $::facts['networking']['ip'],
    hostname => $::facts['networking']['hostname'],
   }
   zabbix::template { 'Template_Linux_App_Apache_rabbitmq': 
	templ_source => 'puppet:///modules/zabbix/templates/Template_Linux_App_Apache_rabbitmq.xml' 
   }
   
   class { 'zbxhelper':
	zabbix_servername => 'central',
   }
   class {'rabbitmq':
   }	
   
   package{'python34-pika':
	ensure=>latest,
   }
   package{'java':
	ensure=>latest,
   }
   package{'java-1.8.0-openjdk-devel':
	ensure=>latest,
   }
   package{'rabbitmq-java-client':
	ensure=>latest,
   }
  #class { 'zabbix_hostgroup':
#	  
#  }
 # class{ '::zabbix_host':
#	hostname => ${facts['networking']['hostname']},
#	ipaddress => ${facts['networking']['ip']},
#
#  } 
}

node /worker.*/ {

}
