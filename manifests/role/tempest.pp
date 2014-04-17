class openstack::role::tempest inherits ::openstack::role {
  class { '::openstack::profile::firewall': }
  class { '::openstack::profile::tempest': }
  class { '::openstack::profile::auth_file': }
}
