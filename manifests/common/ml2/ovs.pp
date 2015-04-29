# Private class
# Set up the OVS agent
class openstack::common::ml2::ovs {
  $data_network        = $::openstack::config::network_data
  $data_address        = ip_for_network($data_network)
  $enable_tunneling    = $::openstack::config::neutron_tunneling # true
  $tunnel_types        = $::openstack::config::neutron_tunnel_types #['gre']
  $arp_responder       = $::openstack::config::neutron_arp_responder
  $l2_population       = $::openstack::config::neutron_l2_population
  $enable_dvr          = $::openstack::config::neutron_enable_dvr

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling           => $enable_tunneling,
    local_ip                   => $data_address,
    enabled                    => true,
    tunnel_types               => $tunnel_types,
    arp_responder              => $arp_responder,
    l2_population              => $l2_population,
    enable_distributed_routing => $enable_dvr,
  }
}
