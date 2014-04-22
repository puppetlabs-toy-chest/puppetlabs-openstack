class havana::role::storage inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::glance::api': }
  class { '::havana::profile::cinder::volume': }

  class { '::havana::setup::cirros': }
}
