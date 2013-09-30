class grizzly::profile::firewall {
  Firewall {
    before  => Class['::grizzly::profile::firewall::post'],
    require => Class['::grizzly::profile::firewall::pre'],
  }

  class { '::firewall': }
}
