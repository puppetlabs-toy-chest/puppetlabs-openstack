class havana::role::storage inherits ::havana::role {
  class { '::havana::profile::glance::api': }
  class { '::havana::profile::cinder::volume': }
}
