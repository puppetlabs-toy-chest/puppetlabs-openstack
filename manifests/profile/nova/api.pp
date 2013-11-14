# The profile to set up the Nova controller (several services)
class havana::profile::nova::api {
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
    fail("Nova API/Scheduler setup failed. The inferred location the
    nova API the havana::network::management::device hiera value is
    ${management_address}. The explicit address
    from havana::controller::address::management is
    ${controller_management_address}. Please correct this difference.")
  }

  if $api_address != $controller_api_address {
    fail("Cinder API/Scheduler setup failed. The inferred location the
    Cinder API the havana::network::api::device hiera value is
    ${api_address}. The explicit address
    from havana::controller::address::api is ${controller_api_address}. Please
    correct this difference.")
  }

  # public API access
  firewall { '8774 - Nova API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8774',
  }

  firewall { '8775 - Nova Metadata':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8775',
  }

  firewall { '6080 - Nova NoVncProxy':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '6080',
  }

  class { '::nova::db::mysql':
    user          => 'nova',
    password      => hiera('havana::nova::sql::password'),
    dbname        => 'nova',
    allowed_hosts => hiera('havana::mysql::allowed_hosts'),
  }

  class { '::nova::keystone::auth':
    password         => hiera('havana::nova::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('havana::region'),
    cinder           => true,
  }

  class { 'havana::profile::nova::common':
    is_controller => true,
  }
}

