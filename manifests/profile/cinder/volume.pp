# The profile to install the volume service
class grizzly::profile::cinder::volume {
  $api_device = hiera('grizzly::network::api::device')
  $api_address = getvar("ipaddress_${api_device}")

  $management_device = hiera('grizzly::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")

  $controller_address = hiera('grizzly::controller::address::management')

  $sql_password = hiera('grizzly::cinder::sql::password')
  $sql_connection =
    "mysql://cinder:${sql_password}@${controller_address}/cinder"


  class { '::cinder':
    sql_connection    => $sql_connection,
    rabbit_host       => $controller_address,
    rabbit_userid     => hiera('grizzly::rabbitmq::user'),
    rabbit_password   => hiera('grizzly::rabbitmq::password'),
    debug             => hiera('grizzly::cinder::debug'),
    verbose           => hiera('grizzly::cinder::verbose'),
  }

  class { '::cinder::setup_test_volume': } ->

  class { '::cinder::volume':
    package_ensure => true,
    enabled        => true,
  }

  class { '::cinder::volume::iscsi':
    iscsi_ip_address => $management_address,
  }
}
