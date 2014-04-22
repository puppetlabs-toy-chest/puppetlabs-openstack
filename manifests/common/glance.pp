# Common class for Glance installation
# Private, and should not be used on its own
# The purpose is to have basic Glance auth configuration options
# set so that services like Tempest can access credentials
# on the controller
class havana::common::glance {
  class { '::glance::api':
    keystone_password => hiera('openstack::glance::password'),
    auth_host         => hiera('openstack::controller::address::management'),
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    sql_connection    => $::havana::resources::connectors::glance,
    registry_host     => hiera('openstack::storage::address::management'),
    verbose           => hiera('openstack::verbose'),
    debug             => hiera('openstack::debug'),
    enabled           => $::havana::profile::base::is_storage,
  }
}
