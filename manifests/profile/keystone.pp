# The profile to install the Keystone service
class havana::profile::keystone {
  ::havana::resources::controller { 'keystone': }
  ::havana::resources::database { 'keystone': }
  ::havana::resources::firewall { 'Keystone API': port => '5000', }

  include ::havana::common::keystone

  class { 'keystone::endpoint':
    public_address   => hiera('openstack::controller::address::api'),
    admin_address    => hiera('openstack::controller::address::management'),
    internal_address => hiera('openstack::controller::address::management'),
    region           => hiera('openstack::region'),
  }

  $tenants = hiera('openstack::tenants')
  $users = hiera('openstack::users')
  create_resources('::havana::resources::tenant', $tenants)
  create_resources('::havana::resources::user', $users)
}
