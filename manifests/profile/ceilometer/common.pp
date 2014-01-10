class havana::profile::ceilometer::common (
  $is_controller = false,
) {
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

  notify { "${controller_management_address}": }

  $mongo_password = hiera('havana::ceilometer::mongo::password')
  $mongo_connection = 
    "mongodb://${controller_management_address}:27017/ceilometer"

  class { '::ceilometer':
    metering_secret => hiera('havana::ceilometer::meteringsecret'),
    debug           => hiera('havana::ceilometer::debug'),
    verbose         => hiera('havana::ceilometer::verbose'),
    rabbit_hosts    => [$controller_management_address],
    rabbit_userid   => hiera('havana::rabbitmq::user'),
    rabbit_password => hiera('havana::rabbitmq::password'),
  }

  class { '::ceilometer::api':
    enabled           => $is_controller,
    keystone_host     => $controller_management_address,
    keystone_password => hiera('havana::ceilometer::password'),
  }

  class { '::ceilometer::db':
    database_connection => $mongo_connection,
  }

  class { 'ceilometer::agent::auth':
    auth_url      => "http://${controller_management_address}:5000/v2.0",
    auth_password => hiera('havana::ceilometer::password'),
  }
}

