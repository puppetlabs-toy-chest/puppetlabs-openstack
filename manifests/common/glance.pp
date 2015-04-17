# Common class for Glance installation
# Private, and should not be used on its own
# The purpose is to have basic Glance auth configuration options
# set so that services like Tempest can access credentials
# on the controller
class openstack::common::glance {
  if $::openstack::profile::base::is_storage {
    class { '::glance::api':
      keystone_password   => $::openstack::glance_password,
      auth_host           => $::openstack::controller_address_management,
      keystone_tenant     => 'services',
      keystone_user       => 'glance',
      database_connection => $::openstack::resources::connectors::glance,
      registry_host       => $::openstack::storage_address_management,
      verbose             => $::openstack::verbose,
      debug               => $::openstack::debug,
      enabled             => $::openstack::profile::base::is_storage,
      mysql_module        => '2.2',
      os_region_name      => $::openstack::region,
    }
  }
}
