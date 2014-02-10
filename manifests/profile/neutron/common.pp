# Sets up configuration common to all neutron nodes.
# Flags install individual services as needed
# This follows the suggest deployment from the neutron Administrator Guide.
class havana::profile::neutron::common {

  $controller_management_address = hiera('havana::controller::address::management')

  $data_device = hiera('havana::network::data::device')
  $data_address = getvar("ipaddress_${data_device}")

  $sql_password = hiera('havana::mysql::service_password')
  $sql_connection =
    "mysql://neutron:${sql_password}@${controller_management_address}/neutron"

  class { '::neutron':
    rabbit_host        => $controller_management_address,
    rabbit_user        => hiera('havana::rabbitmq::user'),
    rabbit_password    => hiera('havana::rabbitmq::password'),
    debug              => hiera('havana::neutron::debug'),
    verbose            => hiera('havana::neutron::verbose'),
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
    sql_connection      => $sql_connection,
    tenant_network_type => 'gre',
  }
}
