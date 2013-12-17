# The base profile for OpenStack. Installs the repository and ntp
class grizzly::profile::base {
  class { '::openstack::repo': }
  class { '::ntp': }
}
