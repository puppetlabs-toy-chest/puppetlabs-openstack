# Common class for Glance installation
# Private, and should not be used on its own
# The purpose is to have basic Glance auth configuration options
# set so that services like Tempest can access credentials
# on the controller
class openstack::common::glance {

  $management_address  = $::openstack::config::controller_address_management
  $user                = $::openstack::config::mysql_user_glance
  $pass                = $::openstack::config::mysql_pass_glance
  $database_connection = "mysql://${user}:${pass}@${management_address}/glance"

  if $::openstack::profile::base::is_storage {
    class { '::glance::api':
      keystone_password   => $::openstack::config::glance_password,
      auth_host           => $::openstack::config::controller_address_management,
      keystone_tenant     => 'services',
      keystone_user       => 'glance',
      database_connection => $database_connection,
      registry_host       => $::openstack::config::storage_address_management,
      verbose             => $::openstack::config::verbose,
      debug               => $::openstack::config::debug,
      enabled             => $::openstack::profile::base::is_storage,
      mysql_module        => '2.2',
      os_region_name      => $::openstack::region,
    }
  }
}
