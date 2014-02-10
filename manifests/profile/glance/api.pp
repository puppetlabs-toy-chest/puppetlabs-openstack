# The profile to install the Glance API and Registry services
# Note that for this configuration API controls the storage,
# so it is on the storage node instead of the control node
class havana::profile::glance::api {
  $api_device = hiera('havana::network::api::device')
  $api_address = getvar("ipaddress_${api_device}")

  $management_device = hiera('havana::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")

  $explicit_management_address = hiera('havana::storage::address::management')
  $explicit_api_address = hiera('havana::storage::address::api')

  $controller_address = hiera('havana::controller::address::management')

  if $management_address != $explicit_management_address {
    fail("Glance Auth setup failed. The inferred location of Glance from
    the havana::network::management::device hiera value i
    ${management_address}. The explicit address from
    havana::storage::address::management is ${explicit_management_address}.
    Please correct this difference.")
  }

  if $api_address != $explicit_api_address {
    fail("Glance Auth setup failed. The inferred location of Glance from
    the havana::network::management::device hiera value is
    ${api_address}. The explicit address from
    havana::storage::address::api is ${explicit_api_address}.
    Please correct this difference.")
  }

  havana::resources::firewall { 'Glance API': port      => '9292', }
  havana::resources::firewall { 'Glance Registry': port => '9191', }

  class { '::glance::api':
    keystone_password => hiera('havana::glance::password'),
    auth_host         => hiera('havana::controller::address::management'),
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    sql_connection    => $sql_connection,
    registry_host     => hiera('havana::storage::address::management'),
    verbose           => hiera('havana::glance::verbose'),
    debug             => hiera('havana::glance::debug'),
  }

  class { '::glance::backend::file': }

  class { '::glance::registry':
    keystone_password => hiera('havana::glance::password'),
    sql_connection    => $::havana::resources::connectors::glance,
    auth_host         => hiera('havana::controller::address::management'),
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    verbose           => true,
    debug             => true,
  }

  class { '::glance::notify::rabbitmq': 
    rabbit_password => hiera('havana::rabbitmq::password'),
    rabbit_userid   => hiera('havana::rabbitmq::user'),
    rabbit_host     => hiera('havana::controller::address::management'),
  }
}
