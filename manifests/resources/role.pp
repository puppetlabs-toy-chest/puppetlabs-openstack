define openstack::resources::role (
) {
  keystone_role { $name:
    ensure => present,
  }
}
