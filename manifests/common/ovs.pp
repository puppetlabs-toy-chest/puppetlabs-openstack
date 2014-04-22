class havana::common::ovs {
  $data_network = hiera('openstack::network::data')
  $data_address = ip_for_network($data_network)

  class { '::neutron::agents::ovs':
    enable_tunneling => 'True',
    local_ip         => $data_address,
    enabled          => true,
    tunnel_types     => ['gre',],
  }

  class  { '::neutron::plugins::ovs':
    tenant_network_type => 'gre',
  }
}
