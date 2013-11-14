# The profile to set up a quantum ovs network router
class grizzly::profile::quantum::router {
  Exec { 
    path => '/usr/bin:/usr/sbin:/bin:/sbin', 
    require => Class['grizzly::profile::quantum::common'],
  } 
  

  ::sysctl::value { 'net.ipv4.ip_forward': 
    value     => '1',
  }

  $controller_management_address = hiera('grizzly::controller::address::management')
  include 'grizzly::profile::quantum::common'

  ### Router service installation
  class { '::quantum::agents::l3':
    debug   => hiera('grizzly::quantum::debug'),
    enabled => true,
  }

  class { '::quantum::agents::dhcp':
    debug   => hiera('grizzly::quantum::debug'),
    enabled => true,
  }

  class { '::quantum::agents::metadata':
    auth_password => hiera('grizzly::quantum::password'),
    shared_secret => hiera('grizzly::quantum::shared_secret'),
    auth_url      => "http://${controller_management_address}:35357/v2.0",
    debug         => hiera('grizzly::quantum::debug'),
    auth_region   => hiera('grizzly::region'),
    metadata_ip   => $controller_management_address,
    enabled       => true,
  }

  # Attempts to set up the external network bridge
  if empty($network_br_ex) {
    $external_device = hiera('grizzly::network::external::device')
    $external_network = hiera('grizzly::network::external')
    $external_ip = getvar("ipaddress_${external_device}")
    $external_ip_subnet = regsubst($external_network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)(/\d+)', "${external_ip}\5")

    exec { '/usr/bin/ovs-vsctl add-br br-ex': } ->
    exec { "/usr/bin/ovs-vsctl add-port br-ex ${external_device}": } ->
    exec { "/sbin/ip addr del ${external_ip_subnet} dev ${external_device}": } ->
    exec { "/sbin/ip addr add ${external_ip_subnet} dev br-ex": }
  }
}
