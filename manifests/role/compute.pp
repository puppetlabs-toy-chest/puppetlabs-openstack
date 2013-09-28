class grizzly::role::compute inherits ::grizzly::role {
  class { '::grizzly::profile::quantum::agent': }
  class { '::grizzly::profile::nova::compute': }
}
