# The profile to install the Keystone service
class openstack::profile::keystone {

  openstack::resources::controller { 'keystone': }
  openstack::resources::database { 'keystone': }
  openstack::resources::firewall { 'Keystone API': port => '5000', }

  include ::openstack::common::keystone

  class { 'keystone::endpoint':
    public_address   => $::openstack::config::controller_address_api,
    admin_address    => $::openstack::config::controller_address_management,
    internal_address => $::openstack::config::controller_address_management,
    region           => $::openstack::config::region,
  }

  $tenants = $::openstack::config::keystone_tenants
  $users   = $::openstack::config::keystone_users
  create_resources('openstack::resources::tenant', $tenants)
  create_resources('openstack::resources::user', $users)
}
