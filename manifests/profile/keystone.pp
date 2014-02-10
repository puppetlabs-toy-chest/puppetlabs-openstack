# The profile to install the Keystone service
class havana::profile::keystone {

  havana::resources::controller { 'keystone': }
  havana::resources::database { 'keystone': }
  havana::resources::firewall { 'Keystone API': port => '5000', }

  class { '::keystone':
    admin_token    => hiera('havana::keystone::admin_token'),
    sql_connection => $::havana::resources::connectors::keystone,
    verbose        => hiera('havana::keystone::verbose'),
    debug          => hiera('havana::keystone::debug'),
  }

  class { '::keystone::roles::admin':
    email        => hiera('havana::keystone::admin_email'),
    password     => hiera('havana::keystone::admin_password'),
    admin_tenant => 'admin',
  }

  class { 'keystone::endpoint':
    public_address   => hiera('havana::controller::address::api'),
    admin_address    => hiera('havana::controller::address::management'),
    internal_address => hiera('havana::controller::address::management'),
    region           => hiera('havana::region'),
  }

  $tenants = hiera('havana::tenants')
  $users = hiera('havana::users')
  create_resources('havana::resources::tenant', $tenants)
  create_resources('havana::resources::user', $users)
}
