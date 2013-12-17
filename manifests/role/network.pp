class grizzly::role::network inherits ::grizzly::role {
  class { '::grizzly::profile::firewall': }
  class { '::grizzly::profile::quantum::router': }
}
