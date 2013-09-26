# The profile to set up the Nova controller (several services)
class grizzly::profile::nova::api {
  $api_device = hiera('grizzly::network::api::device')
  $management_device = hiera('grizzly::network::management::device')
  $data_device = hiera('grizzly::network::data::device')
  $external_device = hiera('grizzly::network::external::device')

  $api_address = getvar("ipaddress_${api_device}")
  $management_address = getvar("ipaddress_${management_device}")
  $data_address = getvar("ipaddress_${data_device}")
  $external_address = getvar("ipaddress_${external_device}")

  $controller_management_address =
    hiera('grizzly::controller::address::management')
  $controller_api_address = hiera('grizzly::controller::address::api')

  if $management_address != $controller_management_address {
    fail("Nova API/Scheduler setup failed. The inferred location the
    nova API the grizzly::network::management::device hiera value is
    ${management_address}. The explicit address
    from grizzly::controller::address::management is
    ${controller_management_address}. Please correct this difference.")
  }

  if $api_address != $controller_api_address {
    fail("Cinder API/Scheduler setup failed. The inferred location the
    Cinder API the grizzly::network::api::device hiera value is
    ${api_address}. The explicit address
    from grizzly::controller::address::api is ${controller_api_address}. Please
    correct this difference.")
  }

  # public API access
  firewall { '8774 - Nova API - API Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8774',
    source => hiera('grizzly::network::api'),
  }

  firewall { '8775 - Nova Metadata - API Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8775',
    source => hiera('grizzly::network::api'),
  }

  firewall { '6080 - Nova NoVncProxy - API Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '6080',
    source => hiera('grizzly::network::api'),
  }

  class { '::nova::db::mysql':
    user          => 'nova',
    password      => hiera('grizzly::nova::sql::password'),
    dbname        => 'nova',
    allowed_hosts => hiera('grizzly::mysql::allowed_hosts'),
  }

  class { '::nova::keystone::auth':
    password         => hiera('grizzly::nova::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('grizzly::region'),
    cinder           => true,
  }

  class { 'grizzly::profile::nova::common':
    is_controller => true,
  }
}

