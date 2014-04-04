class openstack::profile::firewall {
  class { '::openstack::profile::firewall::pre': }
  class { '::openstack::profile::firewall::puppet': }
  class { '::openstack::profile::firewall::post': }
}
