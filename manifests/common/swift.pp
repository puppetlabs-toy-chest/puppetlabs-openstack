class openstack::common::swift {
  class { '::swift':
    swift_hash_suffix => $::openstack::config::swift_hash_suffix,
  }
}
