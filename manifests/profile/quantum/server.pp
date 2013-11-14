# The profile to set up the quantum server
class havana::profile::quantum::server {

  $api_device = hiera('havana::network::api::device')
  $management_device = hiera('havana::network::management::device')
  $data_device = hiera('havana::network::data::device')
  $external_device = hiera('havana::network::external::device')

  $api_address = getvar("ipaddress_${api_device}")
  $management_address = getvar("ipaddress_${management_device}")
  $data_address = getvar("ipaddress_${data_device}")
  $external_address = getvar("ipaddress_${external_device}")

  $controller_management_address = hiera('havana::controller::address::management')
  $controller_api_address = hiera('havana::controller::address::api')

  # public API access
  firewall { '9696 - Quantum API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '9696',
  }

  # This class does not impact the quantum.conf file
  class { '::quantum::db::mysql':
    user          => 'quantum',
    password      => hiera('havana::quantum::sql::password'),
    dbname        => 'quantum',
    allowed_hosts => hiera('havana::mysql::allowed_hosts'),
  }

  class { '::quantum::keystone::auth':
    password         => hiera('havana::quantum::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('havana::region'),
  }

  # Error check the addresses
  if $management_address != $controller_management_address {
    fail("Quantum API/Scheduler setup failed. The inferred location the
    quantum API the havana::network::management::device hiera value is
    ${management_address}. The explicit address
    from havana::controller::address::management is
    ${controller_management_address}. Please correct this difference.")
  }

  if $api_address != $controller_api_address {
    fail("Quantum API/Scheduler setup failed. The inferred location the
    quantum API the havana::network::api::device hiera value is
    ${api_address}. The explicit address
    from havana::controller::address::api is ${controller_api_address}. 
    Please correct this difference.")
  }

  class { '::quantum::server':
    auth_host     => hiera('havana::controller::address::management'),
    auth_password => hiera('havana::quantum::password'),
    enabled       => true,
  }

  include 'havana::profile::quantum::common'
}
