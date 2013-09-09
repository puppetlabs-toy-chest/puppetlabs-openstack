class grizzly::profile::keystone {

  $api_device = hiera('grizzly::network::api::device')
  $management_device = hiera('grizzly::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")
  $api_address = getvar("ipaddress_${api_device}")
  $explicit_address = hiera('grizzly::controller::address')

  if $management_address != $explicit_address {
    fail("Keystone setup failed. The inferred location of keystone on the grizzly::network::management::device hiera value is ${management_address}. The explicit address from grizzly::controller::address is ${explicit_address}. Please correct this difference.")
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
  $sql_address = hiera('grizzly::controller::address')
  $management_network = hiera('grizzly::network::management')

  class { '::keystone::db::mysql':
    user          => 'keystone',
    password      => $sql_password,
    dbname        => 'keystone',
    allowed_hosts => hiera('grizzly::mysql::allowed_hosts'),
  }

  $sql_connection = "mysql://keystone:$sql_password@$sql_address/keystone"

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
}
