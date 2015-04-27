# Common class for ceilometer installation
# Private, and should not be used on its own
class openstack::common::ceilometer {

  class { '::ceilometer':
    metering_secret => $::openstack::config::ceilometer_meteringsecret,
    debug           => $::openstack::config::debug,
    verbose         => $::openstack::config::verbose,
    rabbit_hosts    => $::openstack::config::rabbitmq_hosts,
    rabbit_userid   => $::openstack::config::rabbitmq_user,
    rabbit_password => $::openstack::config::rabbitmq_password,
  }

}

