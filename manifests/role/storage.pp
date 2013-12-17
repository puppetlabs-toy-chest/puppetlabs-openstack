class grizzly::role::storage inherits ::grizzly::role {
  class { '::grizzly::profile::firewall': }
  class { '::grizzly::profile::glance::api': }
  class { '::grizzly::profile::cinder::volume': }
}
