# The base profile for OpenStack. Installs the repository and ntp
class havana::profile::base {
  # everyone also needs to be on the same clock
  class { '::ntp': }

  # all nodes need the OpenStack repository
  class { '::openstack::repo': }

  package { 'python-heatclient':
    ensure  => present,
    version => '0.2.4.1',
  }

  package { 'python-swiftclient':
    ensure  => present,
    version => '1.7.0',
  }

}
