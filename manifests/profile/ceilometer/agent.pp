class havana::profile::ceilometer::agent {
  class { '::havana::profile::ceilometer::common':
    is_controller => false,
  } ->

  class { '::ceilometer::agent::compute':
  }
}
