class havana::role::tempest inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::tempest': }
  class { '::havana::profile::auth_file': }
}
