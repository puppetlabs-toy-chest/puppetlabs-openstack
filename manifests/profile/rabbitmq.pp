# The profile to install rabbitmq and set the firewall
class openstack::profile::rabbitmq {
  $management_address = $::openstack::config::controller_address_management

  if $::osfamily == 'RedHat' {
    #package { 'erlang':
    #  ensure  => installed,
    #  before  => Package['rabbitmq-server'],
    #  require => Yumrepo['erlang-solutions'],
    #}

    package { 'erlang':
      ensure => present,
    }

    Package['erlang'] -> Package['rabbitmq-server']
  }

  ::openstack::resources::firewall { 'RabbitMQ': port => '5672' }
  class { '::nova::rabbitmq':
    userid             => $::openstack::config::rabbitmq_user,
    password           => $::openstack::config::rabbitmq_password,
    rabbitmq_class     => '::rabbitmq',
  }
}
