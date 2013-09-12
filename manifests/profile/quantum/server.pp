# The profile to set up the quantum server
class grizzly::profile::quantum::server {

  $api_device = hiera('grizzly::network::api::device')
  $management_device = hiera('grizzly::network::management::device')
  $data_device = hiera('grizzly::network::data::device')
  $external_device = hiera('grizzly::network::external::device')

  $api_address = getvar("ipaddress_${api_device}")
  $management_address = getvar("ipaddress_${management_device}")
  $data_address = getvar("ipaddress_${data_device}")
  $external_address = getvar("ipaddress_${external_device}")

  $controller_management_address = hiera('grizzly::controller::address::management')
  $controller_api_address = hiera('grizzly::controller::address::api')

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
    source => hiera('grizzly::network::management'),
  }

  # This class does not impact the quantum.conf file
  class { '::quantum::db::mysql':
    user          => 'quantum',
    password      => hiera('grizzly::quantum::sql::password'),
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

  # Error check the addresses
  if $management_address != $controller_management_address {
    fail("Quantum API/Scheduler setup failed. The inferred location the
    quantum API the grizzly::network::management::device hiera value is
    ${management_address}. The explicit address
    from grizzly::controller::address::management is
    ${controller_management_address}. Please correct this difference.")
  }

  if $api_address != $controller_api_address {
    fail("Quantum API/Scheduler setup failed. The inferred location the
    quantum API the grizzly::network::api::device hiera value is
    ${api_address}. The explicit address
    from grizzly::controller::address::api is ${controller_api_address}. 
    Please correct this difference.")
  }

  class { 'grizzly::profile::quantum::common':
    is_controller => true,
  }
}
