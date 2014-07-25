# The profile to install the Glance API and Registry services
# Note that for this configuration API controls the storage,
# so it is on the storage node instead of the control node
class openstack::profile::glance::api {
  $api_network = $::openstack::config::network_api
  $api_address = ip_for_network($api_network)

  $management_network = $::openstack::config::network_management
  $management_address = ip_for_network($management_network)

  $explicit_management_address = $::openstack::config::storage_address_management
  $explicit_api_address = $::openstack::config::storage_address_api

  $controller_address = $::openstack::config::controller_address_management

  if $management_address != $explicit_management_address {
    fail("Glance Auth setup failed. The inferred location of Glance from
    the openstack::network::management hiera value is
    ${management_address}. The explicit address from
    openstack::storage::address::management is ${explicit_management_address}.
    Please correct this difference.")
  }

  if $api_address != $explicit_api_address {
    fail("Glance Auth setup failed. The inferred location of Glance from
    the openstack::network::management hiera value is
    ${api_address}. The explicit address from
    openstack::storage::address::api is ${explicit_api_address}.
    Please correct this difference.")
  }

  openstack::resources::firewall { 'Glance API': port      => '9292', }
  openstack::resources::firewall { 'Glance Registry': port => '9191', }

  include ::openstack::common::glance

  class { '::glance::backend::file': }

  class { '::glance::registry':
    keystone_password => $::openstack::config::glance_password,
    sql_connection    => $::openstack::resources::connectors::glance,
    auth_host         => $::openstack::config::controller_address_management,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    verbose           => $::openstack::config::verbose,
    debug             => $::openstack::config::debug,
    mysql_module      => '2.2',
  }

  class { '::glance::notify::rabbitmq': 
    rabbit_password => $::openstack::config::rabbitmq_password,
    rabbit_userid   => $::openstack::config::rabbitmq_user,
    rabbit_host     => $::openstack::config::controller_address_management,
  }
}
