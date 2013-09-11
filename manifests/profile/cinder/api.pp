# The profile for installing the Cinder API
class grizzly::profile::cinder::api {
  $api_device = hiera('grizzly::network::api::device')
  $api_address = getvar("ipaddress_${api_device}")

  $management_device = hiera('grizzly::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")

  $explicit_management_address =
    hiera('grizzly::controller::address::management')
  $explicit_api_address = hiera('grizzly::controller::address::api')


  if $management_address != $explicit_management_address {
    fail("Cinder API/Scheduler setup failed. The inferred location the
    Cinder API the grizzly::network::management::device hiera value is
    ${management_address}. The explicit address
    from grizzly::controller::address::management is
    ${explicit_management_address}. Please correct this difference.")
  }

  if $api_address != $explicit_api_address {
    fail("Cinder API/Scheduler setup failed. The inferred location the
    Cinder API the grizzly::network::api::device hiera value is
    ${api_address}. The explicit address
    from grizzly::controller::address::api is ${explicit_api_address}. Please
    correct this difference.")
  }

  firewall { '08776 - Cinder API Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8776',
    source => hiera('grizzly::network::api'),
  }

  firewall { '08776 - Cinder Management Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8776',
    source => hiera('grizzly::network::management'),
  }

  $sql_password = hiera('grizzly::cinder::sql::password')
  $sql_connection =
    "mysql://cinder:${sql_password}@${management_address}/cinder"

  class { '::cinder::db::mysql':
    user          => 'cinder',
    password      => $sql_password,
    dbname        => 'cinder',
    allowed_hosts => hiera('grizzly::mysql::allowed_hosts'),
  }

  class { '::cinder::keystone::auth':
    password         => hiera('grizzly::cinder::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('grizzly::region'),
  }


  class { '::cinder':
    sql_connection  => $sql_connection,
    rabbit_hosts    => [ $management_address ],
    rabbit_userid   => hiera('grizzly::rabbitmq::user'),
    rabbit_password => hiera('grizzly::rabbitmq::password'),
    debug           => hiera('grizzly::cinder::debug'),
    verbose         => hiera('grizzly::cinder::verbose'),
  }

  class { '::cinder::api':
    keystone_password  => hiera('grizzly::cinder::password'),
    keystone_auth_host => $management_address
  }

  class { '::cinder::scheduler':
    scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
  }
}
