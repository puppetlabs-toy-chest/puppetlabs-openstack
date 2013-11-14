class havana::role::compute inherits ::havana::role {
  class { '::havana::profile::quantum::agent': }
  class { '::havana::profile::nova::compute': }
}
