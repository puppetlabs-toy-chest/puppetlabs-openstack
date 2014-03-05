# The profile for installing the heat API
class havana::profile::heat::api {
  havana::resources::controller { 'heat': }
  havana::resources::database { 'heat': }
  havana::resources::firewall { 'Heat API': port     => '8004', }
  havana::resources::firewall { 'Heat CFN API': port => '8000', }

  $controller_management_address = hiera('havana::controller::address::management')

  class { '::heat::keystone::auth':
    password         => hiera('havana::heat::password'),
    public_address   => hiera('havana::controller::address::api'),
    admin_address    => hiera('havana::controller::address::management'),
    internal_address => hiera('havana::controller::address::management'),
    region           => hiera('havana::region'),
  }

  class { '::heat::keystone::auth_cfn': 
    password         => hiera('havana::heat::password'),
    public_address   => hiera('havana::controller::address::api'),
    admin_address    => hiera('havana::controller::address::management'),
    internal_address => hiera('havana::controller::address::management'),
    region           => hiera('havana::region'),
  }

  class { '::heat':
    sql_connection    => $::havana::resources::connectors::heat,
    rabbit_host       => hiera('havana::controller::address::management'),
    rabbit_userid     => hiera('havana::rabbitmq::user'),
    rabbit_password   => hiera('havana::rabbitmq::password'),
    debug             => hiera('havana::debug'),
    verbose           => hiera('havana::verbose'),
    keystone_host     => hiera('havana::controller::address::management'),
    keystone_password => hiera('havana::heat::password'),
  }

  class { '::heat::api':
    bind_host => hiera('havana::controller::address::api'),
  }

  class { '::heat::api_cfn':
    bind_host => hiera('havana::controller::address::api'),
  }

  class { '::heat::engine':
    auth_encryption_key => hiera('havana::heat::encryption_key'),
  }
}
