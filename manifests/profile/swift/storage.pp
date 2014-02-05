# The profile for installing a single loopback storage node
class havana::profile::swift::storage (
  $zone = undef,
) {
  $api_device = hiera('havana::network::api::device')
  $management_device = hiera('havana::network::management::device')
  $data_device = hiera('havana::network::data::device')
  $external_device = hiera('havana::network::external::device')

  $api_address = getvar("ipaddress_${api_device}")
  $management_address = getvar("ipaddress_${management_device}")
  $data_address = getvar("ipaddress_${data_device}")
  $external_address = getvar("ipaddress_${external_device}")

  $controller_management_address =
    hiera('havana::controller::address::management')
  $controller_api_address = hiera('havana::controller::address::api')

  $storage_management_address = hiera('havana::storage::address::management')
  $storage_api_address = hiera('havana::storage::address::api')

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
    swift_hash_suffix => hiera('havana::swift::hash_suffix'),
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
    ring_server => $controller_management_address, 
  }
}
