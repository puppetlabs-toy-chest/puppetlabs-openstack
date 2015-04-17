# Common class for ceilometer installation
# Private, and should not be used on its own
class openstack::common::ceilometer {
  $is_controller = $::openstack::profile::base::is_controller

  $ceilometer_management_address = $::openstack::ceilometer_address_management
  $controller_management_address = $::openstack::controller_address_management

  $mongo_username = $::openstack::ceilometer_mongo_username
  $mongo_password = $::openstack::ceilometer_mongo_password

  if ! $mongo_username or ! $mongo_password {
    $mongo_connection = "mongodb://${ceilometer_management_address}:27017/ceilometer"
  } else {
    $mongo_connection = "mongodb://${mongo_username}:${mongo_password}@${ceilometer_management_address}:27017/ceilometer"
  }

  class { '::ceilometer':
    metering_secret => $::openstack::ceilometer_meteringsecret,
    debug           => $::openstack::debug,
    verbose         => $::openstack::verbose,
    rabbit_hosts    => $::openstack::rabbitmq_hosts,
    rabbit_userid   => $::openstack::rabbitmq_user,
    rabbit_password => $::openstack::rabbitmq_password,
  }

  if $is_controller {
    class { '::ceilometer::api':
      enabled           => $is_controller,
      keystone_host     => $controller_management_address,
      keystone_password => $::openstack::ceilometer_password,
    }
  }

  class { '::ceilometer::db':
    database_connection => $mongo_connection,
    mysql_module        => '2.2',
  }

  class { '::ceilometer::agent::auth':
    auth_url      => "http://${controller_management_address}:5000/v2.0",
    auth_password => $::openstack::ceilometer_password,
    auth_region   => $::openstack::region,
  }
}

