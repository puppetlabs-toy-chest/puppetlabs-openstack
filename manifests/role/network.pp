class havana::role::network inherits ::havana::role {
  class { '::havana::profile::neutron::router': }
}
