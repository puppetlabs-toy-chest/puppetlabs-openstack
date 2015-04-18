class openstack::role::storage inherits ::openstack::role {
  class { '::openstack::profile::firewall': }
  class { '::openstack::profile::glance::api': }
  class { '::openstack::profile::cinder::volume': }
}
