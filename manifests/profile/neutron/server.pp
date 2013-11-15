# The profile to set up the neutron server
class havana::profile::neutron::server {

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
  firewall { '9696 - neutron API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '9696',
  }

  # This class does not impact the neutron.conf file
  class { '::neutron::db::mysql':
    user          => 'neutron',
    password      => hiera('havana::neutron::sql::password'),
    dbname        => 'neutron',
    allowed_hosts => hiera('havana::mysql::allowed_hosts'),
  }

  class { '::neutron::keystone::auth':
    password         => hiera('havana::neutron::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('havana::region'),
  }

  # Error check the addresses
  if $management_address != $controller_management_address {
    fail("neutron API/Scheduler setup failed. The inferred location the
    neutron API the havana::network::management::device hiera value is
    ${management_address}. The explicit address
    from havana::controller::address::management is
    ${controller_management_address}. Please correct this difference.")
  }

  if $api_address != $controller_api_address {
    fail("neutron API/Scheduler setup failed. The inferred location the
    neutron API the havana::network::api::device hiera value is
    ${api_address}. The explicit address
    from havana::controller::address::api is ${controller_api_address}. 
    Please correct this difference.")
  }

  class { '::neutron::server':
    auth_host     => hiera('havana::controller::address::management'),
    auth_password => hiera('havana::neutron::password'),
    enabled       => true,
  }

  include 'havana::profile::neutron::common'
}
