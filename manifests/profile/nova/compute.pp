# The puppet module to set up a Nova Compute node
class grizzly::profile::nova::compute {

  $controller_address = hiera('grizzly::controller::address::management')
  $storage_address = hiera('grizzly::storage::address::management')

  $api_device = hiera('grizzly::network::api::device')
  $api_address = getvar("ipaddress_${api_device}")

  $management_device = hiera('grizzly::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")


  $data_device = hiera('grizzly::network::data::device')
  $data_address = getvar("ipaddress_${data_device}")

  $sql_password = hiera('grizzly::nova::sql::password')
  $sql_connection = "mysql://nova:${sql_password}@${management_address}/nova"

  $glance_api_server = "http://${storage_address}:9292"

  class { '::nova':
    sql_connection     => $sql_connection,
    glance_api_servers => $glance_api_server,
    memcached_servers  => ['127.0.0.1:1211'],
    rabbit_hosts       => [$controller_address],
    rabbit_userid      => hiera('grizzly::rabbitmq::user'),
    rabbit_password    => hiera('grizzly::rabbitmq::password'),
    debug              => hiera('grizzly::nova::debug'),
    verbose            => hiera('grizzly::nova::verbose'),
  }

  class { '::nova::compute':
    enabled                       => true,
    vnc_enabled                   => true,
    vncserver_proxyclient_address => $data_address,
    vncproxy_host                 => $controller_address,
  }

  class { '::nova::compute::libvirt':
    libvirt_type     => hiera('grizzly::nova::libvirt_type'),
    vncserver_listen => $management_address,
  }

  class { '::nova::compute::quantum': }

  class { '::nova::network::quantum':
    quantum_admin_password => hiera('grizzly::quantum::password'),
    quantum_region_name    => hiera('grizzly::region'),
    quantum_admin_auth_url => "http://${controller_address}:35357/v2.0",
    quantum_url            => "http://${controller_address}:9696",
  }
}
