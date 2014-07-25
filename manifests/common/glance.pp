# Common class for Glance installation
# Private, and should not be used on its own
# The purpose is to have basic Glance auth configuration options
# set so that services like Tempest can access credentials
# on the controller
class openstack::common::glance {
  class { '::glance::api':
    keystone_password => $::openstack::config::glance_password,
    auth_host         => $::openstack::config::controller_address_management,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    sql_connection    => $::openstack::resources::connectors::glance,
    registry_host     => $::openstack::config::storage_address_management,
    verbose           => $::openstack::config::verbose,
    debug             => $::openstack::config::debug,
    enabled           => $::openstack::profile::base::is_storage,
    mysql_module      => '2.2',
  }
}
