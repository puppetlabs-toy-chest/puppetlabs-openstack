# The profile to install the Keystone service
class grizzly::profile::keystone {
  $api_device = hiera('grizzly::network::api::device')
  $api_address = getvar("ipaddress_${api_device}")

  $management_device = hiera('grizzly::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")

  $explicit_management_address =
    hiera('grizzly::controller::address::management')
  $explicit_api_address = hiera('grizzly::controller::address::api')

  if $management_address != $explicit_management_address {
    fail("Keystone setup failed. The inferred location of keystone
    from the grizzly::network::management::device hiera value is
    ${management_address}. The explicit address
    from grizzly::controller::address is ${explicit_management_address}.
    Please correct this difference.")
  }

  if $api_address != $explicit_api_address {
    fail("Keystone setup failed. The inferred location of keystone
    from the grizzly::network::api::device hiera value is
    ${api_address}. The explicit address
    from grizzly::controller::address::api is ${explicit_api_address}.
    Please correct this difference.")
  }

  firewall { '5000 - Keystone Public API Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '5000',
    source => hiera('grizzly::network::api'),
  }

  firewall { '5000 - Keystone Public Management Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '5000',
    source => hiera('grizzly::network::management'),
  }

  firewall { '35357 - Keystone Admin Management Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '35357',
    source => hiera('grizzly::network::management')
  }

  $sql_password = hiera('grizzly::keystone::sql::password')
  $sql_connection =
    "mysql://keystone:${sql_password}@${management_address}/keystone"

  class { '::keystone::db::mysql':
    user          => 'keystone',
    password      => $sql_password,
    dbname        => 'keystone',
    allowed_hosts => hiera('grizzly::mysql::allowed_hosts'),
  }

  class { '::keystone':
    admin_token    => hiera('grizzly::keystone::admin_token'),
    sql_connection => $sql_connection,
    verbose        => hiera('grizzly::keystone::verbose'),
    debug          => hiera('grizzly::keystone::debug'),
  }

  class { '::keystone::roles::admin':
    email        => hiera('grizzly::keystone::admin_email'),
    password     => hiera('grizzly::keystone::admin_password'),
    admin_tenant => 'admin',
  }

  class { 'keystone::endpoint':
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('grizzly::region'),
  }


  $tenants = hiera('grizzly::tenants')
  $users = hiera('grizzly::users')
  create_resources('grizzly::resources::tenant', $tenants)
  create_resources('grizzly::resources::user', $users)
}
