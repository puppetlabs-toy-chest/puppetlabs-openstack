# The profile to set up the quantum server
class grizzly::profile::quantum::server {
  $api_device = hiera('grizzly::network::api::device')
  $api_address = getvar("ipaddress_${api_device}")

  $management_device = hiera('grizzly::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")

  $data_device = hiera('grizzly::network::data::device')
  $data_address = getvar("ipaddress_${data_device}")

  $explicit_management_address =
    hiera('grizzly::controller::address::management')
  $explicit_api_address = hiera('grizzly::controller::address::api')

  if $management_address != $explicit_management_address {
    fail("Quantum API/Scheduler setup failed. The inferred location the
    quantum API the grizzly::network::management::device hiera value is
    ${management_address}. The explicit address
    from grizzly::controller::address::management is
    ${explicit_management_address}. Please correct this difference.")
  }

  if $api_address != $explicit_api_address {
    fail("Quantum API/Scheduler setup failed. The inferred location the
    quantum API the grizzly::network::api::device hiera value is
    ${api_address}. The explicit address
    from grizzly::controller::address::api is ${explicit_api_address}. Please
    correct this difference.")
  }

  # public API access
  firewall { '9696 - quantum API - API Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '9696',
    source => hiera('grizzly::network::api'),
  }

  # private API access
  firewall { '9696 - quantum API - Management Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '9696',
    source => hiera('grizzly::network::api'),
  }

  $sql_password = hiera('grizzly::quantum::sql::password')
  $sql_connection =
    "mysql://quantum:${sql_password}@${management_address}/quantum"

  class { '::quantum::db::mysql':
    user          => 'quantum',
    password      => $sql_password,
    dbname        => 'quantum',
    allowed_hosts => hiera('grizzly::mysql::allowed_hosts'),
  }

  class { '::quantum::keystone::auth':
    password         => hiera('grizzly::quantum::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('grizzly::region'),
  }

  class { '::quantum':
    rabbit_host        => $management_address,
    rabbit_user        => hiera('grizzly::rabbitmq::user'),
    rabbit_password    => hiera('grizzly::rabbitmq::password'),
    debug              => hiera('grizzly::quantum::debug'),
    verbose            => hiera('grizzly::quantum::verbose'),
  }

  class { '::keystone::client': } ->
  class { '::quantum::server':
    auth_host     => $management_address,
    auth_password => hiera('grizzly::quantum::password'),
  }

  class  { 'quantum::plugins::ovs':
    sql_connection      => $sql_connection,
    tenant_network_type => 'gre',
  }

  class { 'quantum::agents::ovs':
    enable_tunneling => 'True',
    local_ip         => $data_address,
    enabled          => false,
  }
}
