# The profile for installing the heat API
class openstack::profile::heat::api {

  openstack::resources::database { 'heat': }
  openstack::resources::firewall { 'Heat API': port     => '8004', }
  openstack::resources::firewall { 'Heat CFN API': port => '8000', }

  $controller_management_address = $::openstack::config::controller_address_management
  $user                          = $::openstack::config::mysql_user_heat
  $pass                          = $::openstack::config::mysql_pass_heat
  $database_connection           = "mysql://${user}:${pass}@${controller_management_address}/heat"

  class { '::heat::keystone::auth':
    password         => $::openstack::config::heat_password,
    public_address   => $::openstack::config::controller_address_api,
    admin_address    => $::openstack::config::controller_address_management,
    internal_address => $::openstack::config::controller_address_management,
    region           => $::openstack::config::region,
  }

  class { '::heat::keystone::auth_cfn':
    password         => $::openstack::config::heat_password,
    public_address   => $::openstack::config::controller_address_api,
    admin_address    => $::openstack::config::controller_address_management,
    internal_address => $::openstack::config::controller_address_management,
    region           => $::openstack::config::region,
  }

  class { '::heat':
    database_connection => $database_connection,
    rabbit_host         => $::openstack::config::controller_address_management,
    rabbit_userid       => $::openstack::config::rabbitmq_user,
    rabbit_password     => $::openstack::config::rabbitmq_password,
    debug               => $::openstack::config::debug,
    verbose             => $::openstack::config::verbose,
    keystone_host       => $::openstack::config::controller_address_management,
    keystone_password   => $::openstack::config::heat_password,
    mysql_module        => '2.2',
  }

  class { '::heat::api':
    bind_host => $::openstack::config::controller_address_api,
  }

  class { '::heat::api_cfn':
    bind_host => $::openstack::config::controller_address_api,
  }

  class { '::heat::engine':
    auth_encryption_key => $::openstack::config::heat_encryption_key,
  }
}
