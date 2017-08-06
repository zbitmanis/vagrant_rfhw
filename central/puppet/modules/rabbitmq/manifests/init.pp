class rabbitmq (  $nodename         = 'rmqserver',
                  $ensure           = 'running',
                  $enable           = true,
                  $package          = $rabbitmq::params::package,
                  $service          = $rabbitmq::params::service,
                  $config           = $rabbitmq::params::config,
                  $template         = $rabbitmq::params::template,
                  
  ) inherits rabbitmq::params {
    
    include stdlib

     if $rabbitmq::params::supported == true {
       anchor  { 'rabbitmq::start':}->
       class   { 'rabbitmq::package':}~>
       class   { 'rabbitmq::config':}~>
       class   { 'rabbitmq::service':}~>
       anchor  { 'rabbitmq::end':}
     }    
  }