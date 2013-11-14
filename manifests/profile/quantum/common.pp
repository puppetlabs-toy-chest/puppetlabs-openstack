# Sets up configuration common to all quantum nodes.
# Flags install individual services as needed
# This follows the suggest deployment from the Quantum Administrator Guide.
class havana::profile::quantum::common {
  $api_device = hiera('havana::network::api::device')
  $management_device = hiera('havana::network::management::device')
  $data_device = hiera('havana::network::data::device')
  $external_device = hiera('havana::network::external::device')

  $api_address = getvar("ipaddress_${api_device}")
  $management_address = getvar("ipaddress_${management_device}")
  $data_address = getvar("ipaddress_${data_device}")
  $external_address = getvar("ipaddress_${external_device}")

  $controller_management_address = hiera('havana::controller::address::management')
  $controller_api_address = hiera('havana::controller::address::api')

  $sql_password = hiera('havana::quantum::sql::password')
  $sql_connection =
    "mysql://quantum:${sql_password}@${controller_management_address}/quantum"

  class { '::quantum':
    rabbit_host        => $controller_management_address,
    rabbit_user        => hiera('havana::rabbitmq::user'),
    rabbit_password    => hiera('havana::rabbitmq::password'),
    debug              => hiera('havana::quantum::debug'),
    verbose            => hiera('havana::quantum::verbose'),
  }

  # everone gets an ovs agent (TODO true?)
  class { '::quantum::agents::ovs':
    enable_tunneling => 'True',
    local_ip         => $data_address,
    enabled          => true,
  }

  # everyone gets an ovs plugin (TODO true?)
  class  { '::quantum::plugins::ovs':
    sql_connection      => $sql_connection,
    tenant_network_type => 'gre',
  }
}
