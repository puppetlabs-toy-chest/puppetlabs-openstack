class havana::role::swiftstorage (
  $zone = undef,
) inherits ::havana::role  {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::swift::storage': zone => $zone }
}
