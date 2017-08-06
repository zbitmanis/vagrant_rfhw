class rabbitmq::package {
  package { $rabbitmq::package: ensure => installed }
}