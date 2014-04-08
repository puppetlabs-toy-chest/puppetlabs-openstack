# Common class for Glance installation
# Private, and should not be used on its own
# The purpose is to have basic Glance auth configuration options
# set so that services like Tempest can access credentials
# on the controller
class openstack::common::glance {
  $is_storage = $::openstack::profile::base::is_storage

  class { '::glance::api':
    keystone_password => hiera('openstack::glance::password'),
    auth_host         => hiera('openstack::controller::address::management'),
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    sql_connection    => $::openstack::resources::connectors::glance,
    registry_host     => hiera('openstack::storage::address::management'),
    verbose           => hiera('openstack::verbose'),
    debug             => hiera('openstack::debug'),
    enabled           => $is_storage,
  }
}
