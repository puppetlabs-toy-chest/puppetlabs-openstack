define havana::setup::router (
  $network,
  $subnet,
) {
  $tenant = $title

  neutron_router { $tenant:
    tenant_name          => $tenant,
    gateway_network_name => 'public',
    require              => [Neutron_network['public'], Neutron_subnet["${subnet}"]]
  } ->
  neutron_port { "${tenant}_${network}_${subnet}":
    ensure       => present,
    network_name => $network,
    subnet_name  => $subnet,
  } ->
  neutron_router_interface  { "${tenant}:${subnet}":
    ensure => present,
    port   => "${tenant}_${network}_${subnet}",
  }
}
