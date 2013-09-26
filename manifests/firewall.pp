class grizzly::firewall {
  Firewall {
    before  => Class['::grizzly::firewall::post'],
    require => Class['::grizzly::firewall::pre'],
  }

#  class { ['::grizzly::firewall::pre', '::grizzly::firewall::post'] }

  class { '::firewall': }
}
