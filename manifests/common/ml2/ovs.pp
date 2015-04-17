# Private class
# Set up the OVS agent
class openstack::common::ml2::ovs {
  $data_network        = $::openstack::network_data
  $data_address        = ip_for_network($data_network)
  $enable_tunneling    = $::openstack::neutron_tunneling # true
  $tunnel_types        = $::openstack::neutron_tunnel_types #['gre']

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => $enable_tunneling,
    local_ip         => $data_address,
    enabled          => true,
    tunnel_types     => $tunnel_types,
  }
}
