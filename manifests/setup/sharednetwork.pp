# A static class to set up a shared network. Should appear on the
# controller node. It sets up the public network, a private network,
# two subnets (one for admin, one for test), and the routers that
# connect the subnets to the public network.
#
# After this class has run, you should have a functional network
# avaiable for your test user to launch and connect machines to.
class openstack::setup::sharednetwork {

  $external_network = $::openstack::config::network_external
  $start_ip = $::openstack::config::network_external_ippool_start
  $end_ip   = $::openstack::config::network_external_ippool_end
  $ip_range = "start=${start_ip},end=${end_ip}"
  $gateway  = $::openstack::config::network_external_gateway
  $dns      = $::openstack::config::network_external_dns

  $private_network = $::openstack::config::network_neutron_private

  neutron_network { 'public':
    tenant_name              => 'services',
    provider_network_type    => 'gre',
    router_external          => true,
    provider_segmentation_id => 3604,
    shared                   => true,
  } ->

  neutron_subnet { $external_network:
    cidr             => $external_network,
    ip_version       => '4',
    gateway_ip       => $gateway,
    enable_dhcp      => false,
    network_name     => 'public',
    tenant_name      => 'services',
    allocation_pools => [$ip_range],
    dns_nameservers  => [$dns],
  }

  neutron_network { 'private':
    tenant_name              => 'services',
    provider_network_type    => 'gre',
    router_external          => false,
    provider_segmentation_id => 4063,
    shared                   => true,
  } ->

  neutron_subnet { $private_network:
    cidr             => $private_network,
    ip_version       => '4',
    enable_dhcp      => true,
    network_name     => 'private',
    tenant_name      => 'services',
    dns_nameservers  => [$dns],
  } 

  openstack::setup::router { "test:${private_network}": }
}
