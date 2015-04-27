# The profile to install the Keystone service
class openstack::profile::keystone {

  openstack::resources::database { 'keystone': }
  openstack::resources::firewall { 'Keystone API': port => '5000', }

  include ::openstack::common::keystone

  class { '::keystone::roles::admin':
    email        => $::openstack::config::keystone_admin_email,
    password     => $::openstack::config::keystone_admin_password,
    admin_tenant => 'admin',
  }

  class { 'keystone::endpoint':
    public_url   => "http://${::openstack::config::controller_address_api}:5000",
    admin_url    => "http://${::openstack::config::controller_address_management}:35357",
    internal_url => "http://${::openstack::config::controller_address_management}:5000",
    region       => $::openstack::config::region,
  }

  if $::openstack::config::keystone_use_httpd == true {
    class { '::keystone::wsgi::apache':
      ssl => false,
    }
  }

  $tenants = $::openstack::config::keystone_tenants
  $users   = $::openstack::config::keystone_users
  create_resources('keystone_tenant', $tenants)
  create_resources('openstack::resources::user', $users)
}
