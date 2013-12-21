class havana::profile::ceilometer::agent {
  class { '::ceilometer::agent::compute':
  }

  class { '::havana::profile::ceilometer::common':
    is_controller => false,
  }
}
