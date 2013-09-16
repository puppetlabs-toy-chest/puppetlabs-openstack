# common configuration for the nova services
class grizzly::profile::nova::common (
  $is_controller = false,
  $is_compute    = false,
) {
  $api_device = hiera('grizzly::network::api::device')
  $management_device = hiera('grizzly::network::management::device')
  $data_device = hiera('grizzly::network::data::device')
  $external_device = hiera('grizzly::network::external::device')

  $api_address = getvar("ipaddress_${api_device}")
  $management_address = getvar("ipaddress_${management_device}")
  $data_address = getvar("ipaddress_${data_device}")
  $external_address = getvar("ipaddress_${external_device}")

  $controller_management_address =
    hiera('grizzly::controller::address::management')
  $controller_api_address = hiera('grizzly::controller::address::api')

  $storage_management_address = hiera('grizzly::storage::address::management')
  $storage_api_address = hiera('grizzly::storage::address::api')

  $glance_api_server = "http://${storage_management_address}:9292"

  $sql_password = hiera('grizzly::nova::sql::password')
  $sql_connection =
    "mysql://nova:${sql_password}@${controller_management_address}/nova"

  class { '::nova':
    sql_connection     => $sql_connection,
    glance_api_servers => $glance_api_server,
    memcached_servers  => ["${controller_management_address}:11211"],
    rabbit_hosts       => [$controller_management_address],
    rabbit_userid      => hiera('grizzly::rabbitmq::user'),
    rabbit_password    => hiera('grizzly::rabbitmq::password'),
    debug              => hiera('grizzly::nova::debug'),
    verbose            => hiera('grizzly::nova::verbose'),
  }

  class { '::nova::api':
    admin_password  => hiera('grizzly::nova::password'),
    auth_host       => $controller_management_address,
    enabled         => $is_controller,
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

  class { '::nova::compute::libvirt':
    libvirt_type     => hiera('grizzly::nova::libvirt_type'),
    vncserver_listen => $management_address,
  }

  class { '::nova::compute::quantum': }

  class { '::nova::network::quantum':
    quantum_admin_password => hiera('grizzly::quantum::password'),
    quantum_region_name    => hiera('grizzly::region'),
    quantum_admin_auth_url => "http://${controller_management_address}:35357/v2.0",
    quantum_url            => "http://${controller_management_address}:9696",
  }
}
