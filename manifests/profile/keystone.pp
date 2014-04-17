# The profile to install the Keystone service
class openstack::profile::keystone {

  openstack::resources::controller { 'keystone': }
  openstack::resources::database { 'keystone': }
  openstack::resources::firewall { 'Keystone API': port => '5000', }

  include ::openstack::common::keystone

  class { 'keystone::endpoint':
    public_address   => hiera('openstack::controller::address::api'),
    admin_address    => hiera('openstack::controller::address::management'),
    internal_address => hiera('openstack::controller::address::management'),
    region           => hiera('openstack::region'),
  }

  $tenants = hiera('openstack::tenants')
  $users = hiera('openstack::users')
  create_resources('openstack::resources::tenant', $tenants)
  create_resources('openstack::resources::user', $users)
}
