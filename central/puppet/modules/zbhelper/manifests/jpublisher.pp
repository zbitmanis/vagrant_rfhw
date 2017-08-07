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
  require => [ Package['java-devel'], Package['rabbitmq-java-client'], File["${path}/src/${src_name}.java"] ]
 }

$strcontent ="#!/bin/bash 
for (( i =0; i<100; i++ )); do 
_RND=$((1 + RANDOM % 10))
/bin/java -cp ${path}/bin/:/usr/share/java/rabbitmq-java-client.jar ${src_name} \$_RND
done 
"

$rcontent ="#!/bin/bash 
#!/bin/bash

_A=\$1

if [ \"\$_A\" -eq \"\$_A\" ] 2>/dev/null; then
/bin/java -cp ${path}/bin/:/usr/share/java/rabbitmq-java-client.jar ${src_name} \$_A
else
  echo \"Integer argument required\"
fi
"

file { "${path}/bin/stress.sh":
      content => $strcontent,
      mode => '755'  
    }

file { "${path}/bin/jpublish.sh":
      content => $rcontent,
      mode => '755'  
    }

}
