class grizzly::profile::base {
  # all nodes need the OpenStack repository
  include ::openstack::repo

  # everyone also needs to be on the same clock
  include ::ntp
}
