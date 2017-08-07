class zbhelper::jpublisher( 
$src_name = 'AMQPublisher',
$source = "puppet:///modules/zbhelper/${src_name}.java", 
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
 file {"${path}/src/${src_name}.java":
    ensure =>'file',
    source => $source, 
    require => File["${path}/src"],
    notify => Exec["javac -d bin -sourcepath src -cp /usr/share/java/rabbitmq-java-client.jar src/${src_name}.java"],
 }
 
 exec { "javac -d bin -sourcepath src -cp /usr/share/java/rabbitmq-java-client.jar src/${src_name}.java" :
  cwd     => "${path}",
  creates => "${path}/bin/${src_name}.class",
  path    => ['/usr/bin', '/bin',],
  subscribe => File["${path}/src/${src_name}.java"],
  require => [ Package['java-devel'], Package['rabbitmq-java-client'] ]
 }

}
