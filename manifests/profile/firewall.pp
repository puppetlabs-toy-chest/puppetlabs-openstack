class openstack::profile::firewall {
  if $::osfamily == 'RedHat' and $::operatingsystemmajversion == 7 {
    package { 'iptables-services':
      ensure => present,
    }
    Package['iptables-services'] -> Firewall<||>
  }
  class { '::openstack::profile::firewall::pre': }
  class { '::openstack::profile::firewall::puppet': }
  class { '::openstack::profile::firewall::post': }
}
