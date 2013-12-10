# The profile to set up a neutron ovs network router
class havana::profile::neutron::router {
  Exec { 
    path => '/usr/bin:/usr/sbin:/bin:/sbin', 
    require => Class['havana::profile::neutron::common'],
  } 
  
  ::sysctl::value { 'net.ipv4.ip_forward': 
    value     => '1',
  }

  $controller_management_address = hiera('havana::controller::address::management')
  include 'havana::profile::neutron::common'

  ### Router service installation
  class { '::neutron::agents::l3':
    debug   => hiera('havana::neutron::debug'),
    enabled => true,
  }

  class { '::neutron::agents::dhcp':
    debug   => hiera('havana::neutron::debug'),
    enabled => true,
  }

  class { '::neutron::agents::metadata':
    auth_password => hiera('havana::neutron::password'),
    shared_secret => hiera('havana::neutron::shared_secret'),
    auth_url      => "http://${controller_management_address}:35357/v2.0",
    debug         => hiera('havana::neutron::debug'),
    auth_region   => hiera('havana::region'),
    metadata_ip   => $controller_management_address,
    enabled       => true,
  }

  vs_bridge { 'br-ex':
    ensure => present,
  }

  $external_device = hiera('havana::network::external::device')

  vs_port { $external_device:
    ensure  => present,
    bridge  => 'br-ex',
    keep_ip => true,
  }
}
