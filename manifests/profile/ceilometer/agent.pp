class openstack::profile::ceilometer::agent {
  $controller_management_address = $::openstack::config::controller_address_management
  include ::openstack::common::ceilometer
  class { '::ceilometer::agent::auth':
    auth_url      => "http://${controller_management_address}:5000/v2.0",
    auth_password => $::openstack::config::ceilometer_password,
    auth_region   => $::openstack::config::region,
  }
  class { '::ceilometer::agent::compute': }
}
