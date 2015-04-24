# The profile to install rabbitmq and set the firewall
class openstack::profile::rabbitmq {
  $management_address = $::openstack::controller_address_management

  if $::osfamily == 'RedHat' {
    package { 'erlang':
      ensure => installed,
      before => Package['rabbitmq-server'],
    }
    # Erlang solutions doesn't have a yum repo for Fedora >= 17, but Fedora has an up-to-date erlang
    if $::operatingsystem != 'Fedora' {
      Yumrepo['erlang-solutions'] -> Package['erlang']
    }
  }

  rabbitmq_user { $::openstack::rabbitmq_user:
    admin    => true,
    password => $::openstack::rabbitmq_password,
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }
  rabbitmq_user_permissions { "${openstack::rabbitmq_user}@/":
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
