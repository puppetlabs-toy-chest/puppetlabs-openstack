class openstack::common::ovs {
  $data_network        = $::openstack::config::network_data
  $data_address        = ip_for_network($data_network)
  $enable_tunneling    = $::openstack::config::neutron_tunneling # true
  $tunnel_types        = $::openstack::config::neutron_tunnel_types #['gre']
  $tenant_network_type = $::openstack::config::neutron_tenant_network_type # ['gre']
  $type_drivers        = $::openstack::config::neutron_type_drivers # ['gre']
  $mechanism_drivers   = $::openstack::config::neutron_mechanism_drivers # ['openvswitch']
  $tunnel_id_ranges    = $::openstack::config::neutron_tunnel_id_ranges # ['1:1000']
  $bridge_uplinks      = $::openstack::config::neutron_bridge_uplinks # ['brex:bond1']
  $bridge_mappings     = $::openstack::config::neutron_bridge_mappings # ['default:brex']
  $network_vlan_ranges = $::openstack::config::neutron_network_vlan_ranges # ['default:1:1000']

  class { '::neutron::agents::ml2::ovs':
    enabled          => true,
    enable_tunneling => $enable_tunneling,
    tunnel_types     => $tunnel_types,
    local_ip         => $data_address,
    bridge_uplinks   => $bridge_uplinks ,
    bridge_mappings  => $bridge_mappings,
  }

  class  { '::neutron::plugins::ml2':
    type_drivers         => $type_drivers,
    tenant_network_types => $tenant_network_type,
    mechanism_drivers    => $mechanism_drivers,
    tunnel_id_ranges     => $tunnel_id_ranges,
    network_vlan_ranges  => $network_vlan_ranges,
  }
}
