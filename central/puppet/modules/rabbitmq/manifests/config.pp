class rabbitmq::config {
  file { $rabbitmq::config:  
    ensure  => present,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template("${module_name}/${rabbitmq::template}"),
  }
}