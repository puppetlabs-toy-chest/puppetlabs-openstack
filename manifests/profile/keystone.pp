# The profile to install the Keystone service
class havana::profile::keystone {
  $api_device = hiera('havana::network::api::device')
  $api_address = getvar("ipaddress_${api_device}")

  $management_device = hiera('havana::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")

  $explicit_management_address =
    hiera('havana::controller::address::management')
  $explicit_api_address = hiera('havana::controller::address::api')

  if $management_address != $explicit_management_address {
    fail("Keystone setup failed. The inferred location of keystone
    from the havana::network::management::device hiera value is
    ${management_address}. The explicit address
    from havana::controller::address is ${explicit_management_address}.
    Please correct this difference.")
  }

  if $api_address != $explicit_api_address {
    fail("Keystone setup failed. The inferred location of keystone
    from the havana::network::api::device hiera value is
    ${api_address}. The explicit address
    from havana::controller::address::api is ${explicit_api_address}.
    Please correct this difference.")
  }

  firewall { '5000 - Keystone API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '5000',
    source => hiera('havana::network::api'),
  }

  $sql_password = hiera('havana::keystone::sql::password')
  $sql_connection =
    "mysql://keystone:${sql_password}@${management_address}/keystone"

  class { '::keystone::db::mysql':
    user          => 'keystone',
    password      => $sql_password,
    dbname        => 'keystone',
    allowed_hosts => hiera('havana::mysql::allowed_hosts'),
  }

  class { '::keystone':
    admin_token    => hiera('havana::keystone::admin_token'),
    sql_connection => $sql_connection,
    verbose        => hiera('havana::keystone::verbose'),
    debug          => hiera('havana::keystone::debug'),
  }

  class { '::keystone::roles::admin':
    email        => hiera('havana::keystone::admin_email'),
    password     => hiera('havana::keystone::admin_password'),
    admin_tenant => 'admin',
  }

  class { 'keystone::endpoint':
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('havana::region'),
  }


  $tenants = hiera('havana::tenants')
  $users = hiera('havana::users')
  create_resources('havana::resources::tenant', $tenants)
  create_resources('havana::resources::user', $users)
}
