# Private class
class openstack::common::ml2 {
  $tenant_network_type = $::openstack::config::neutron_tenant_network_type # ['gre']
  $type_drivers        = $::openstack::config::neutron_type_drivers # ['gre']
  $mechanism_drivers   = $::openstack::config::neutron_mechanism_drivers # ['openvswitch']
  $tunnel_id_ranges    = $::openstack::config::neutron_tunnel_id_ranges # ['1:1000']

  class  { '::neutron::plugins::ml2':
    type_drivers         => $type_drivers,
    tenant_network_types => $tenant_network_type,
    mechanism_drivers    => $mechanism_drivers,
    tunnel_id_ranges     => $tunnel_id_ranges
  }
}
