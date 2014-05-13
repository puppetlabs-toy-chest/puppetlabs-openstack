class openstack::common::ovs {
  $data_network = hiera('openstack::network::data')
  $data_address = ip_for_network($data_network)
  $enable_tunneling = hiera('openstack::neutron::tunneling', true)
  $tunnel_types = hiera('openstack::neutron::tunnel_types', [])
  $tenant_network_type = hiera('openstack::neutron::tenant_network_type', 'gre')

  class { '::neutron::agents::ovs':
    enable_tunneling => $enable_tunneling,
    local_ip         => $data_address,
    enabled          => true,
    tunnel_types     => $tunnel_types,
  }

  class  { '::neutron::plugins::ovs':
    tenant_network_type => $tenant_network_type,
  }
}
