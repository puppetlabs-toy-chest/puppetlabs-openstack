# The profile to install rabbitmq and set the firewall
class openstack::profile::rabbitmq {
  $management_address = $::openstack::config::controller_address_management

  include erlang

  rabbitmq_user { $::openstack::config::rabbitmq_user:
    admin    => true,
    password => $::openstack::config::rabbitmq_password,
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }
  rabbitmq_user_permissions { "${openstack::config::rabbitmq_user}@/":
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
  }->Anchor<| title == 'nova-start' |>

  class { '::rabbitmq':
    service_ensure    => 'running',
    port              => 5672,
    delete_guest_user => true,
  }
}
