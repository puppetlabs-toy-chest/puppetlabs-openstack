class havana::profile::ceilometer::agent {
  class { '::havana::common::ceilometer': } ->
  class { '::ceilometer::agent::compute': }
}
