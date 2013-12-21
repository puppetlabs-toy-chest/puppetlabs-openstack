# The profile to set up the Ceilometer API
class havana::profile::ceilometer::api {
  $api_device = hiera('havana::network::api::device')
  $management_device = hiera('havana::network::management::device')
  $data_device = hiera('havana::network::data::device')
  $external_device = hiera('havana::network::external::device')

  $api_address = getvar("ipaddress_${api_device}")
  $management_address = getvar("ipaddress_${management_device}")
  $data_address = getvar("ipaddress_${data_device}")
  $external_address = getvar("ipaddress_${external_device}")

  $controller_management_address =
    hiera('havana::controller::address::management')
  $controller_api_address = hiera('havana::controller::address::api')

  if $management_address != $controller_management_address {
    fail("Ceilometer API/Scheduler setup failed. The inferred location the
    nova API the havana::network::management::device hiera value is
    ${management_address}. The explicit address
    from havana::controller::address::management is
    ${controller_management_address}. Please correct this difference.")
  }

  if $api_address != $controller_api_address {
    fail("Ceilometer API/Scheduler setup failed. The inferred location the
    Cinder API the havana::network::api::device hiera value is
    ${api_address}. The explicit address
    from havana::controller::address::api is ${controller_api_address}. Please
    correct this difference.")
  }

  # public API access
  firewall { '8777 - Ceilometer API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8774',
  }

  class { '::ceilometer::keystone::auth':
    password         => hiera('havana::ceilometer::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('havana::region'),
  }

  class { 'ceilometer::agent::central':
  }

  class { 'ceilometer::expirer':
    time_to_live => '2592000'
  }

  class { 'ceilometer::alarm::notifier':
  }

  class { 'ceilometer::alarm::evaluator':
  }

  class { '::havana::profile::ceilometer::common':
    is_controller => true,
  }
}
