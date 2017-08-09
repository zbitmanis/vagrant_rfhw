class zbhelper::psleeper( 
$path = '/opt/zb',
) {

 file {$path :
    ensure =>'directory'
 }

 file {"${path}/bin":
    ensure =>'directory'
 }

 file {"${path}/src":
    ensure =>'directory',
    require => File[ $path ]
 }

 file {"${path}/bin/zba.py":
    ensure =>'file',
    source => "puppet:///modules/zbhelper/zba.py", 
    mode => '755',
    require => [ File["${path}/bin"],File["${path}/bin/sleeper.py"] , Package['python-daemon'], Package['python-pika']],
 }

 package{ 'epel-release': 
 	ensure=>'latest'
 }

 package{ 'python-daemon': 
	ensure=>'latest',
 	require=> Package['epel-release']
 }

 package{ 'python-pika': 
	ensure=>'latest',
 	require=>Package['epel-release']
 }

 file {"${path}/bin/sleeper.py":
    ensure =>'file',
    source => "puppet:///modules/zbhelper/sleeper.py", 
    mode => '644',
    require => File["${path}/bin"],
 }

 group { 'sleeper':
    ensure => 'present',
 }

 user { 'sleeper':
	ensure           => 'present',
	gid              => 'sleeper',
	home             => '/var/lib/sleeper',
	password         => '!!',
	password_max_age => '99999',
	password_min_age => '0',
	shell            => '/bin/bash',
	#uid              => '501',
	require => Group['sleeper']
  }  

  file { '/var/run/sleeper' :
    ensure =>'directory',
    owner=>'sleeper',
    require => User['sleeper']
  	
  }
  file { '/var/log/sleeper' :
    ensure =>'directory',
    owner=>'sleeper',
    require => User['sleeper']
  	
  }

  include ::systemd
  file { '/usr/lib/systemd/system/sleeper.service':
  		ensure => file,
		owner  => 'root',
  		group  => 'root',
	  	mode   => '0644',
  		source => "puppet:///modules/zbhelper/sleeper.service",
		require=> [ File['/var/log/sleeper'], File['/var/run/sleeper'], File["${path}/bin/zba.py"], User['sleeper'] ],
  } ~> Exec['systemctl-daemon-reload'] 
  
  service {'sleeper':
	ensure=>'running',
        require => File[ '/usr/lib/systemd/system/sleeper.service']    
  }  	
   
}
