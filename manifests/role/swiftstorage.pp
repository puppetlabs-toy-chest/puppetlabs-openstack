class openstack::role::swiftstorage (
  $zone = undef,
) inherits ::openstack::role  {
  class { '::openstack::profile::firewall': }
  class { '::openstack::profile::swift::storage': zone => $zone }
}
