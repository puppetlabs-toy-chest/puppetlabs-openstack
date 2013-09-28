class grizzly::firewall {
  Firewall {
    before  => Class['::grizzly::firewall::post'],
    require => Class['::grizzly::firewall::pre'],
  }

  notify { 'Firewall presets initialized': }

  class { '::firewall': }
}
