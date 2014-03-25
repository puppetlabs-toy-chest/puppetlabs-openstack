class havana::role::compute inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::neutron::agent': }
  class { '::havana::profile::nova::compute': }
  class { '::havana::profile::ceilometer::agent': }
}
