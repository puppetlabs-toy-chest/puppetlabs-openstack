# Common class for neutron installation
# Private, and should not be used on its own
# Sets up configuration common to all neutron nodes.
# Flags install individual services as needed
# This follows the suggest deployment from the neutron Administrator Guide.
class havana::common::neutron {
  $controller_management_address = hiera('havana::controller::address::management')

  $data_network = hiera('havana::network::data')
  $data_address = ip_for_network($data_network)

  class { '::neutron':
    rabbit_host        => $controller_management_address,
    rabbit_user        => hiera('havana::rabbitmq::user'),
    rabbit_password    => hiera('havana::rabbitmq::password'),
    debug              => hiera('havana::debug'),
    verbose            => hiera('havana::verbose'),
  }

  # everone gets an ovs agent (TODO true?)
  class { '::neutron::agents::ovs':
    enable_tunneling => 'True',
    local_ip         => $data_address,
    enabled          => true,
    tunnel_types     => ['gre',],
  }

  # everyone gets an ovs plugin (TODO true?)
  class  { '::neutron::plugins::ovs':
    sql_connection      => $::havana::resources::connectors::neutron,
    tenant_network_type => 'gre',
  }
}
