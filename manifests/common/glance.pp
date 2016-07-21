# Common class for Glance installation
# Private, and should not be used on its own
# The purpose is to have basic Glance auth configuration options
# set so that services like Tempest can access credentials
# on the controller
class openstack::common::glance {
  $management_network = $::openstack::config::network_management
  $management_address = ip_for_network($management_network)

  $storage_management_address = $::openstack::config::storage_address_management
  $controller_management_address = $::openstack::config::controller_address_management

  class { '::glance::api':
    keystone_password   => $::openstack::config::glance_password,
    auth_uri            => "http://${controller_management_address}:5000/",
    identity_uri        => "http://${controller_management_address}:35357/",
    keystone_tenant     => 'services',
    keystone_user       => 'glance',
    database_connection => $::openstack::resources::connectors::glance,
    registry_host       => $storage_management_address,
    verbose             => $::openstack::config::verbose,
    debug               => $::openstack::config::debug,
    enabled             => $::openstack::profile::base::is_storage,
    os_region_name      => $::openstack::region,
  }
}
