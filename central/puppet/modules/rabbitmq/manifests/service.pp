class rabbitmq::service {
  service { $rabbitmq::service:
    ensure => $rabbitmq::ensure,
    enable => $rabbitmq::enable,
  }
}