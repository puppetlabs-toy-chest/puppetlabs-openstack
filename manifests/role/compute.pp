class havana::role::compute inherits ::havana::role {
  class { '::havana::profile::neutron::agent': }
  class { '::havana::profile::nova::compute': }
}
