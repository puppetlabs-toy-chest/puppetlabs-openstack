# common configuration for the nova services
class havana::profile::nova::common (
  $is_controller = false,
  $is_compute    = false,
) {
  $api_device = hiera('havana::network::api::device')
  $management_device = hiera('havana::network::management::device')
  $data_device = hiera('havana::network::data::device')
  $external_device = hiera('havana::network::external::device')

  $api_address = getvar("ipaddress_${api_device}")
  $management_address = getvar("ipaddress_${management_device}")
  $data_address = getvar("ipaddress_${data_device}")
  $external_address = getvar("ipaddress_${external_device}")

  $controller_management_address =
    hiera('havana::controller::address::management')
  $controller_api_address = hiera('havana::controller::address::api')

  $storage_management_address = hiera('havana::storage::address::management')
  $storage_api_address = hiera('havana::storage::address::api')

  $glance_api_server = "http://${storage_management_address}:9292"

  $sql_password = hiera('havana::nova::sql::password')
  $sql_connection =
    "mysql://nova:${sql_password}@${controller_management_address}/nova"

  class { '::nova':
    sql_connection     => $sql_connection,
    glance_api_servers => $glance_api_server,
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
    host    => $controller_api_address,
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
    vncproxy_host                 => $controller_api_address,
  }

  class { '::nova::compute::neutron': }

  class { '::nova::network::neutron':
    neutron_admin_password => hiera('havana::neutron::password'),
    neutron_region_name    => hiera('havana::region'),
    neutron_admin_auth_url => "http://${controller_management_address}:35357/v2.0",
    neutron_url            => "http://${controller_management_address}:9696",
  }
}
