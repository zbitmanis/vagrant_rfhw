
  $zabbix_servername = 'central'
  $zabbix_hostgroup = 'Linux servers'
  $zabbix_url = 'localhost'
  $zabbix_user = 'Admin'   
  $zabbix_pass = 'zabbix'
  $serverip = zbhelper::ns_resolve ($zabbix_servername) 
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
  #$myip=$::facts['networking']['ip']
  #$myhost=$::facts['networking']['hostname']
  #notify  {"MyIP is ${myip} ( ${facts['networking']['ip']}) MyHost ${myhost} ( ${facts['networking']['hostname']}  ": }
  
   class { 'zabbix::agent':
    server => "127.0.0.1,${serverip} ",
    hostname => $::facts['networking']['hostname'],
    listenip => '0.0.0.0',	
   }

   file { '/etc/zabbix/Template_Linux_App_rabbitmq.xml': 
       source => 'puppet:///modules/zabbix/templates/Template_Linux_App_rabbitmq.xml' 

  }
  zabbix_template { 'Template_Linux_App_RabbitMQ': 
     template_source => '/etc/zabbix/Template_Linux_App_rabbitmq.xml',
     zabbix_url => 'localhost',    
     zabbix_user => 'Admin',   
     zabbix_pass => 'zabbix',
     require =>[ File['/etc/zabbix/Template_Linux_App_rabbitmq.xml'] ,  Class['Zabbix'] ] 
  }
  	
  zabbix_host { $::facts['networking']['hostname']:
	ipaddress => $::facts['networking']['ip'],
	group => $zabbix_hostgroup, 
	templates => ['Template_Linux_App_RabbitMQ','Template OS Linux','Template App SSH Service'] , 
        zabbix_url => $zabbix_url,
        zabbix_user => $zabbix_user,
        zabbix_pass => $zabbix_pass, 
        port => 10050,
        require => [ Class['Zabbix::Agent'] , Class['Zabbix']  ]
       }
  	 
#   class { 'zbxhelper':
#	   zabbix_servername => 'central',
#     require  =>Class['zabbix']
#   }
   class { 'zbhelper::jpublisher':
   }

   class {'rabbitmq':
   }	
   
   package{'python34-pika':
    ensure=>latest,
   }
   package{'java':
    ensure=>latest,
   }
   package{'java-devel':
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
