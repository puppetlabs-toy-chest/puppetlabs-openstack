# The profile for installing the Cinder API
class havana::profile::cinder::api {
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

  $storage_management_address = hiera('havana::storage::address::management')
  $storage_api_address = hiera('havana::storage::address::api')

  $sql_password = hiera('havana::cinder::sql::password')

  if $management_address != $controller_management_address {
    fail("Cinder API/Scheduler setup failed. The inferred location the
    Cinder API the havana::network::management::device hiera value is
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

  firewall { '08776 - Cinder API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8776',
  }

  class { '::cinder::db::mysql':
    user          => 'cinder',
    password      => hiera('havana::cinder::sql::password'),
    dbname        => 'cinder',
    allowed_hosts => hiera('havana::mysql::allowed_hosts'),
  }

  class { '::cinder::keystone::auth':
    password         => hiera('havana::cinder::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('havana::region'),
  }

  include '::havana::profile::cinder::common'

  class { '::cinder::api':
    keystone_password  => hiera('havana::cinder::password'),
    keystone_auth_host => hiera('havana::controller::address::management'),
    enabled            => true,
  }

  class { '::cinder::scheduler':
    scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
    enabled          => true,
  }
}
