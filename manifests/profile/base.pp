# The base profile for OpenStack. Installs the repository and ntp
class havana::profile::base {
  # Set up the initial firewall rules for all nodes

  resources { "firewall":
    purge => true,
  }

  class { '::firewall': }

  # basic firewall rules to match general os rules
  class { '::havana::profile::firewall::pre': }

  # all nodes should have the puppet firewall
  class { '::havana::profile::firewall::puppet': }

  # all nodes need the OpenStack repository
  class { '::openstack::repo': }

  # everyone also needs to be on the same clock
  class { '::ntp': }

  # secure the system by rejecting all other traffic
  class { '::havana::profile::firewall::post': }
}
