class grizzly::profile::glance::api {
  $api_device = hiera('grizzly::network::api::device')
  $management_device = hiera('grizzly::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")
  $api_address = getvar("ipaddress_${api_device}")
  $explicit_address = hiera('grizzly::controller::address')

  if $management_address != $explicit_address {
    fail("Glance API setup failed. The inferred location of keystone on the grizzly::network::management::device hiera value is ${management_address}. The explicit address from grizzly::controller::address is ${explicit_address}. Please correct this difference.")
  }

  notify { "TODO: glance::api profile": }
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

  $db_password = hiera('grizzly::glance::sql::password')

  # database setup
  class { '::glance::db::mysql':
    user          => 'glance',
    password      => hiera('grizzly::glance::sql::password'),
    dbname        => 'glance',
    allowed_hosts => hiera('grizzly::mysql::allowed_hosts'),
  } 

  $glance_sql_connection = "mysql://glance:$db_password@$management_address/glance"

  # Keystone setup for Glance. Creates glance admin user and creates catalog settings
  # sets the glance user to be 'glance', tenant 'services'
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
