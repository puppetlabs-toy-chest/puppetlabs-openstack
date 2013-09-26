# The profile to set up a quantum ovs network router
class grizzly::profile::quantum::router {
  Exec { 
    path => '/usr/bin:/usr/sbin:/bin:/sbin', 
    require => Class['grizzly::profile::quantum::common'],
  } 
  

  ::sysctl::value { 'net.ipv4.ip_forward': 
    value     => '1',
  }

  class {'grizzly::profile::quantum::common':
    is_router => true,
  } 

  # Attempts to set up the external network bridge
  if empty($network_br_ex) {
    $external_device = hiera('grizzly::network::external::device')
    $external_network = hiera('grizzly::network::external')
    $external_ip = getvar("ipaddress_${external_device}")
    $external_ip_subnet = regsubst($external_network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)(/\d+)', "${external_ip}\5")

    exec { '/usr/bin/ovs-vsctl add-br br-ex': } ->
    exec { "/usr/bin/ovs-vsctl add-port br-ex ${external_device}": }
    exec { "/sbin/ip addr del ${external_ip_subnet} dev ${external_device}": }
    exec { "/sbin/ip addr add ${external_ip_subnet} dev br-ex": }
  }
}
