# The profile to install rabbitmq and set the firewall
class openstack::profile::rabbitmq {
  $management_address = $::openstack::config::controller_address_management

  ::openstack::resources::firewall { 'RabbitMQ': port => '5672' }

  class { '::nova::rabbitmq':
    userid             => $::openstack::config::rabbitmq_user,
    password           => $::openstack::config::rabbitmq_password,
  }
}
