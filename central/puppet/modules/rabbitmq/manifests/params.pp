class rabbitmq::params {
  case $::operatingsystem {
        /(Redhat|CentOS|Fedora)/: {
          $supported  = true
          $package    = 'rabbitmq-server'
          $service    = 'rabbitmq-server'
          $config     = '/etc/rabbitmq/rabbitmq-env.conf'
          $template   = 'rabbitmq-env.erb'
        }
        default: {
          $supported = false
          notify { "${module_name}_unsupported":
            message => "The ${module_name} module is not support on ${::operatingsystem}",
          }
        }
      }
}