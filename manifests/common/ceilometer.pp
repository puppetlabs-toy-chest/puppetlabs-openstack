# Common class for ceilometer installation
# Private, and should not be used on its own
class openstack::common::ceilometer {
  $is_controller = $::openstack::profile::base::is_controller

  $controller_management_address = hiera('openstack::controller::address::management')

  $mongo_password = hiera('openstack::ceilometer::mongo::password')
  $mongo_connection = 
    "mongodb://${controller_management_address}:27017/ceilometer"

  class { '::ceilometer':
    metering_secret => hiera('openstack::ceilometer::meteringsecret'),
    debug           => hiera('openstack::debug'),
    verbose         => hiera('openstack::verbose'),
    rabbit_hosts    => [$controller_management_address],
    rabbit_userid   => hiera('openstack::rabbitmq::user'),
    rabbit_password => hiera('openstack::rabbitmq::password'),
  }

  class { '::ceilometer::api':
    enabled           => $is_controller,
    keystone_host     => $controller_management_address,
    keystone_password => hiera('openstack::ceilometer::password'),
  }

  class { '::ceilometer::db':
    database_connection => $mongo_connection,
  }

  class { '::ceilometer::agent::auth':
    auth_url      => "http://${controller_management_address}:5000/v2.0",
    auth_password => hiera('openstack::ceilometer::password'),
    auth_region   => hiera('openstack::region'),
  }
}

