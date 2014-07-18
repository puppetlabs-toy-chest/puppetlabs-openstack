# The profile for installing the heat API
class openstack::profile::heat::api {
  openstack::resources::controller { 'heat': }
  openstack::resources::database { 'heat': }
  openstack::resources::firewall { 'Heat API': port     => '8004', }
  openstack::resources::firewall { 'Heat CFN API': port => '8000', }

  $controller_management_address = $::openstack::config::controller_address_management

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
    sql_connection    => $::openstack::resources::connectors::heat,
    rabbit_host       => $::openstack::config::controller_address_management,
    rabbit_userid     => $::openstack::config::rabbitmq_user,
    rabbit_password   => $::openstack::config::rabbitmq_password,
    debug             => $::openstack::config::debug,
    verbose           => $::openstack::config::verbose,
    keystone_host     => $::openstack::config::controller_address_management,
    keystone_password => $::openstack::config::heat_password,
    mysql_module      => '2.2',
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
