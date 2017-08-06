node 'central' {
  class { 'apache':
    mpm_module => 'prefork',
    default_vhost => false,	
  }
  include apache::mod::php

  class { 'mysql::server': }

  class { 'zabbix':
    zabbix_url    => 'control',
    database_type => 'mysql',
	zabbix_timezone => 'Europe/Riga',
	default_vhost => true,
	zabbix_api_user =>  'capi',
	zabbix_api_pass => 'i6htnXdeWjex4z',
  }
#  class { 'zabbix::web':
#  }	
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
}

node /worker.*/ {

}
