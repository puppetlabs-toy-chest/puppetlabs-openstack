class grizzly::profile::glance::api {
  $api_device = hiera('grizzly::network::api::device')
  $api_address = getvar("ipaddress_${api_device}")

  $management_device = hiera('grizzly::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")

  $explicit_address = hiera('grizzly::controller::address')

  if $management_address != $explicit_address {
    fail("Glance API setup failed. The inferred location of Glance from
    the grizzly::network::management::device hiera value is 
    ${management_address}. The explicit address from 
    grizzly::controller::address is ${explicit_address}. 
    Please correct this difference.")
  }

  # public API access
  firewall { '09292 - Glance API API Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '9292',
    source => hiera('grizzly::network::api'),
  }

  # private API access
  firewall { '09292 - Glance API Management Network':
    proto         => 'tcp',
    state         => ['NEW'],
    action        => 'accept',
    port          => '9292',
    source        => hiera('grizzly::network::management'),
  }

  $sql_password = hiera('grizzly::glance::sql::password')
  $sql_connection = "mysql://glance:$sql_password@$management_address/glance"

  # database setup
  class { '::glance::db::mysql':
    user          => 'glance',
    password      => $sql_password,
    dbname        => 'glance',
    allowed_hosts => hiera('grizzly::mysql::allowed_hosts'),
  } 

  class  { '::glance::keystone::auth':
    password         => hiera('grizzly::glance::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('grizzly::region'),
  }

  class { '::glance::api':
    keystone_password => hiera('grizzly::glance::password'),
    auth_host         => $management_address,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    sql_connection    => $sql_connection,
    registry_host     => hiera('grizzly::storage::address'),
    verbose           => hiera('grizzly::glance::verbose'),
    debug             => hiera('grizzly::glance::debug'),
  }
}
