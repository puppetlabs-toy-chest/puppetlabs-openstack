class openstack::profile::ceilometer::agent {
  class { '::openstack::common::ceilometer': } ->
  class { '::ceilometer::agent::compute': }
}
