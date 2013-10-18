# The base profile for OpenStack. Installs the repository and ntp
class grizzly::profile::base {
  # Set up the initial firewall rules for all nodes

  resources { "firewall":
    purge => true,
  }

  class { '::firewall': }

  class { '::grizzly::profile::firewall::pre': }

  # all nodes should have the puppet firewall

  class { '::grizzly::profile::firewall::puppet': }

  # all nodes need the OpenStack repository
  class { '::openstack::repo': }

  # everyone also needs to be on the same clock
  class { '::ntp': }
  class { '::grizzly::profile::firewall::post': }
}
