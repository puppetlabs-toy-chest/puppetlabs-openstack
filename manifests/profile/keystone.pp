# The profile to install the Keystone service
class openstack::profile::keystone {

  openstack::resources::controller { 'keystone': }
  openstack::resources::database { 'keystone': }
  openstack::resources::firewall { 'Keystone API': port => '5000', }

  include ::openstack::common::keystone

  class { 'keystone::endpoint':
    public_url   => "http://${::openstack::controller_address_api}:5000",
    admin_url    => "http://${::openstack::controller_address_management}:35357",
    internal_url => "http://${::openstack::controller_address_management}:5000",
    region       => $::openstack::region,
  }

  if $::openstack::keystone_use_httpd == true {
    class { '::keystone::wsgi::apache':
      ssl => false,
    }
  }

  $tenants = $::openstack::keystone_tenants
  $users   = $::openstack::keystone_users
  create_resources('openstack::resources::tenant', $tenants)
  create_resources('openstack::resources::user', $users)
}
