class openstack::role::compute inherits ::openstack::role {
  class { '::openstack::profile::firewall': }
  class { '::openstack::profile::neutron::agent': }
  class { '::openstack::profile::nova::compute': }
  class { '::openstack::profile::ceilometer::agent': }
}
