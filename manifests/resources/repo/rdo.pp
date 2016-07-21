class openstack::resources::repo::rdo(
  $release = 'mitaka'
) {
  class { 'openstack_extras::repo::redhat::redhat':
    release => $release
  }
}
