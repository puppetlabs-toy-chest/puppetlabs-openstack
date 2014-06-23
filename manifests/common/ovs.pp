class openstack::common::ovs {
  $data_network = hiera('openstack::network::data')
  $data_address = ip_for_network($data_network)
  $enable_tunneling = hiera('openstack::neutron::tunneling', true)
  $tunnel_types = hiera('openstack::neutron::tunnel_types', ['gre'])
  $tenant_network_type = hiera('openstack::neutron::tenant_network_type', ['gre'])
  $type_drivers = hiera('openstack::neutron::type_drivers', ['gre'])
  $mechanism_drivers = hiera('openstack::neutron::mechanism_drivers', ['openvswitch'])
  $tunnel_id_ranges = hiera('openstack::neutron::tunnel_id_ranges', ['1:1000'])

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => $enable_tunneling,
    local_ip         => $data_address,
    enabled          => true,
    tunnel_types     => $tunnel_types,
  }

  class  { '::neutron::plugins::ml2':
    type_drivers      => $type_drivers,
    tenant_network_types => $tenant_network_type,
    mechanism_drivers => $mechanism_drivers,
    tunnel_id_ranges  => $tunnel_id_ranges
  }
}
