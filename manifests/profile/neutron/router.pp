# The profile to set up a neutron ovs network router
class openstack::profile::neutron::router {
  ::sysctl::value { 'net.ipv4.ip_forward':
    value     => '1',
  }

  $controller_management_address = $::openstack::controller_address_management

  include ::openstack::common::neutron
  include ::openstack::common::ml2::ovs
  include ::openstack::common::ml2


  ### Router service installation
  class { '::neutron::agents::l3':
    debug                   => $::openstack::debug,
    external_network_bridge => 'brex',
    enabled                 => true,
  }

  class { '::neutron::agents::dhcp':
    debug   => $::openstack::debug,
    enabled => true,
  }

  class { '::neutron::agents::metadata':
    auth_password => $::openstack::neutron_password,
    shared_secret => $::openstack::neutron_shared_secret,
    auth_url      => "http://${controller_management_address}:35357/v2.0",
    debug         => $::openstack::debug,
    auth_region   => $::openstack::region,
    metadata_ip   => $controller_management_address,
    enabled       => true,
  }

  class { '::neutron::agents::lbaas':
    debug   => $::openstack::debug,
    enabled => true,
  }

  class { '::neutron::agents::vpnaas':
    enabled => true,
  }

  class { '::neutron::agents::metering':
    enabled => true,
  }

  class { '::neutron::services::fwaas':
    enabled => true,
  }

  $external_bridge = 'brex'
  $external_network = $::openstack::network_external
  $external_device = device_for_network($external_network)
  vs_bridge { $external_bridge:
    ensure => present,
  }
  if $external_device != $external_bridge {
    vs_port { $external_device:
      ensure => present,
      bridge => $external_bridge,
    }
  } else {
    # External bridge already has the external device's IP, thus the external
    # device has already been linked
  }
}
