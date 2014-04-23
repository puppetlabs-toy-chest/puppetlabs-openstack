# The profile for installing the heat API
class openstack::profile::heat::api {
  openstack::resources::controller { 'heat': }
  openstack::resources::database { 'heat': }
  openstack::resources::firewall { 'Heat API': port     => '8004', }
  openstack::resources::firewall { 'Heat CFN API': port => '8000', }

  $controller_management_address = hiera('openstack::controller::address::management')

  class { '::heat::keystone::auth':
    password         => hiera('openstack::heat::password'),
    public_address   => hiera('openstack::controller::address::api'),
    admin_address    => hiera('openstack::controller::address::management'),
    internal_address => hiera('openstack::controller::address::management'),
    region           => hiera('openstack::region'),
  }

  class { '::heat::keystone::auth_cfn': 
    password         => hiera('openstack::heat::password'),
    public_address   => hiera('openstack::controller::address::api'),
    admin_address    => hiera('openstack::controller::address::management'),
    internal_address => hiera('openstack::controller::address::management'),
    region           => hiera('openstack::region'),
  }

  class { '::heat':
    sql_connection    => $::openstack::resources::connectors::heat,
    rabbit_host       => hiera('openstack::controller::address::management'),
    rabbit_userid     => hiera('openstack::rabbitmq::user'),
    rabbit_password   => hiera('openstack::rabbitmq::password'),
    debug             => hiera('openstack::debug'),
    verbose           => hiera('openstack::verbose'),
    keystone_host     => hiera('openstack::controller::address::management'),
    keystone_password => hiera('openstack::heat::password'),
    mysql_module      => '2.2',
  }

  class { '::heat::api':
    bind_host => hiera('openstack::controller::address::api'),
  }

  class { '::heat::api_cfn':
    bind_host => hiera('openstack::controller::address::api'),
  }

  class { '::heat::engine':
    auth_encryption_key => hiera('openstack::heat::encryption_key'),
  }
}
