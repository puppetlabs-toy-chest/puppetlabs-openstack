# The profile for installing a single loopback storage node
class openstack::profile::swift::storage (
  $zone = undef,
) {
  $management_network = $::openstack::config::network_management
  $management_address = ip_for_network($management_network)

  firewall { '6000 - Swift Object Store':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '',
  }

  firewall { '6001 - Swift Container Store':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '6001',
  }

  firewall { '6002 - Swift Account Store':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '6002',
  }

  class { '::swift':
    swift_hash_suffix => $::openstack::config::swift_hash_suffix,
  }

  swift::storage::loopback { '1':
    base_dir     => '/srv/swift-loopback',
    mnt_base_dir => '/srv/node',
    byte_size    => 1024,
    seek         => 10000,
    fstype       => 'ext4',
    require      => Class['swift'],
  }

  class { '::swift::storage::all':
    storage_local_net_ip => $management_address
  }

  @@ring_object_device { "${management_address}:6000/1":
    zone   => $zone,
    weight => 1,
  }

  @@ring_container_device { "${management_address}:6001/1":
    zone   => $zone,
    weight => 1,
  }

  @@ring_account_device { "${management_address}:6002/1":
    zone   => $zone,
    weight => 1,
  }

  swift::ringsync { ['account','container','object']: 
    ring_server => $::openstack::config::controller_address_management, 
  }
}
