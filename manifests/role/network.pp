class havana::role::network inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::neutron::router': }
  class { '::havana::setup::sharednetwork': }
}
