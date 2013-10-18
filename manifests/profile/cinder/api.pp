# The profile for installing the Cinder API
class grizzly::profile::cinder::api {
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

  $storage_management_address = hiera('grizzly::storage::address::management')
  $storage_api_address = hiera('grizzly::storage::address::api')

  $sql_password = hiera('grizzly::cinder::sql::password')

  if $management_address != $controller_management_address {
    fail("Cinder API/Scheduler setup failed. The inferred location the
    Cinder API the grizzly::network::management::device hiera value is
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

  firewall { '08776 - Cinder API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8776',
  }

  class { '::cinder::db::mysql':
    user          => 'cinder',
    password      => hiera('grizzly::cinder::sql::password'),
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

  class { '::grizzly::profile::cinder::common':
    is_controller => true,
  }
}
