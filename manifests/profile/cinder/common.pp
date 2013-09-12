# common configuration for cinder profiles
class grizzly::profile::cinder::common (
  $is_controller = false,
  $is_volume     = false,
) {
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
  $sql_connection =
    "mysql://cinder:${sql_password}@${controller_management_address}/cinder"

  class { '::cinder':
    sql_connection    => $sql_connection,
    rabbit_host       => $controller_management_address,
    rabbit_userid     => hiera('grizzly::rabbitmq::user'),
    rabbit_password   => hiera('grizzly::rabbitmq::password'),
    debug             => hiera('grizzly::cinder::debug'),
    verbose           => hiera('grizzly::cinder::verbose'),
  }

  class { '::cinder::api':
    keystone_password  => hiera('grizzly::cinder::password'),
    keystone_auth_host => $controller_management_address,
    enabled            => $is_controller,
  }

  class { '::cinder::scheduler':
    scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
    enabled          => $is_controller,
  }

  if $is_volume {
    class { '::cinder::setup_test_volume': } ->

    class { '::cinder::volume':
      package_ensure => true,
      enabled        => true,
    }
  }
  else {
    class { '::cinder::volume':
      package_ensure => true,
      enabled        => false,
    }
  }
}
