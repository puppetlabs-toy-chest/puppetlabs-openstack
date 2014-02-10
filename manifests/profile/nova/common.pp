# common configuration for the nova services
class havana::profile::nova::common (
  $is_controller = false,
  $is_compute    = false,
) {
  $management_device = hiera('havana::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")

  $storage_management_address = hiera('havana::storage::address::management')

  $sql_password = hiera('havana::mysql::service_password')
  $controller_management_address = hiera('havana::controller::address::management')
  $sql_connection = "mysql://nova:${sql_password}@${controller_management_address}/nova"

  class { '::nova':
    sql_connection     => $sql_connection,
    glance_api_servers => "http://${storage_management_address}:9292",
    memcached_servers  => ["${controller_management_address}:11211"],
    rabbit_hosts       => [$controller_management_address],
    rabbit_userid      => hiera('havana::rabbitmq::user'),
    rabbit_password    => hiera('havana::rabbitmq::password'),
    debug              => hiera('havana::nova::debug'),
    verbose            => hiera('havana::nova::verbose'),
  }

  class { '::nova::api':
    admin_password                       => hiera('havana::nova::password'),
    auth_host                            => $controller_management_address,
    enabled                              => $is_controller,
    neutron_metadata_proxy_shared_secret => hiera('havana::neutron::shared_secret'),
  }

  class { '::nova::vncproxy':
    host    => hiera('havana::controller::address::api'),
    enabled => $is_controller,
  }

  class { [
    'nova::scheduler',
    'nova::objectstore',
    'nova::cert',
    'nova::consoleauth',
    'nova::conductor'
  ]:
    enabled => $is_controller,
  }

  # TODO: it's important to set up the vnc properly
  class { '::nova::compute':
    enabled                       => $is_compute,
    vnc_enabled                   => true,
    vncserver_proxyclient_address => $management_address,
    vncproxy_host                 => hiera('havana::controller::address::api'),
  }

  class { '::nova::compute::neutron': }

  class { '::nova::network::neutron':
    neutron_admin_password => hiera('havana::neutron::password'),
    neutron_region_name    => hiera('havana::region'),
    neutron_admin_auth_url => "http://${controller_management_address}:35357/v2.0",
    neutron_url            => "http://${controller_management_address}:9696",
  }
}
