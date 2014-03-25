class havana::profile::firewall {
  class { '::havana::profile::firewall::pre': }
  class { '::havana::profile::firewall::puppet': }
  class { '::havana::profile::firewall::post': }
}
