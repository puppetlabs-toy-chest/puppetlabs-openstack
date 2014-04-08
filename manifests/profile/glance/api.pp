# The profile to install the Glance API and Registry services
# Note that for this configuration API controls the storage,
# so it is on the storage node instead of the control node
class openstack::profile::glance::api {
  $api_network = hiera('openstack::network::api')
  $api_address = ip_for_network($api_network)

  $management_network = hiera('openstack::network::management')
  $management_address = ip_for_network($management_network)

  $explicit_management_address = hiera('openstack::storage::address::management')
  $explicit_api_address = hiera('openstack::storage::address::api')

  $controller_address = hiera('openstack::controller::address::management')

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
    keystone_password => hiera('openstack::glance::password'),
    sql_connection    => $::openstack::resources::connectors::glance,
    auth_host         => hiera('openstack::controller::address::management'),
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    verbose           => hiera('openstack::verbose'),
    debug             => hiera('openstack::debug'),
  }

  class { '::glance::notify::rabbitmq': 
    rabbit_password => hiera('openstack::rabbitmq::password'),
    rabbit_userid   => hiera('openstack::rabbitmq::user'),
    rabbit_host     => hiera('openstack::controller::address::management'),
  }
}
