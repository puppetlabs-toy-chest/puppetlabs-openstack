# The profile to set up the endpoints, auth, and database for Glance
# Because of the include, api must come before auth if colocated
class havana::profile::glance::auth {
  ::havana::resources::controller { 'glance': }
  ::havana::resources::database { 'glance': }

  class  { '::glance::keystone::auth':
    password         => hiera('openstack::glance::password'),
    public_address   => hiera('openstack::storage::address::api'),
    admin_address    => hiera('openstack::storage::address::management'),
    internal_address => hiera('openstack::storage::address::management'),
    region           => hiera('openstack::region'),
  }

  include ::havana::common::glance
}
