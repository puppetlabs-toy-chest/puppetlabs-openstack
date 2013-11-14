# common configuration for cinder profiles
class havana::profile::cinder::common {
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
  $sql_connection =
    "mysql://cinder:${sql_password}@${controller_management_address}/cinder"

  class { '::cinder':
    sql_connection    => $sql_connection,
    rabbit_host       => $controller_management_address,
    rabbit_userid     => hiera('havana::rabbitmq::user'),
    rabbit_password   => hiera('havana::rabbitmq::password'),
    debug             => hiera('havana::cinder::debug'),
    verbose           => hiera('havana::cinder::verbose'),
  }
}
