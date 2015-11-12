class openstack::profile::ironic {
  openstack::resources::controller { 'ironic': }
  openstack::resources::firewall { 'Ironic API': port => '6385' }

  class { "::ironic::db::mysql":
    user          => 'ironic',
    password      => $::openstack::config::mysql_service_password,
    dbname        => 'ironic',
    allowed_hosts => $::openstack::config::mysql_allowed_hosts,
    require       => Anchor['database-service'],
  }

  $controller_management_address = $::openstack::config::controller_address_management

  class { '::ironic::keystone::auth':
    password         => $::openstack::config::ironic_password,
    public_address   => $::openstack::config::controller_address_api,
    admin_address    => $::openstack::config::controller_address_management,
    internal_address => $::openstack::config::controller_address_management,
    region           => $::openstack::config::region,
  }

  class { '::ironic':
    enabled             => true,
    database_connection => $::openstack::resources::connectors::ironic,
    glance_api_servers  => "http://${storage_management_address}:9292",
    rabbit_hosts        => [$controller_management_address],
    rabbit_userid       => $::openstack::config::rabbitmq_user,
    rabbit_password     => $::openstack::config::rabbitmq_password,
    debug               => $::openstack::config::debug,
    verbose             => $::openstack::config::verbose,
    glance_api_insecure => true,
  }

  class { '::ironic::api':
    admin_password => $::openstack::config::ironic_password,
    auth_host      => $controller_management_address,
    enabled        => $is_controller,
  }

  class { '::ironic::conductor': }

  class { '::ironic::drivers::ipmi': }

  class { '::ironic::drivers::pxe':
    deploy_kernel  => $::openstack::ironic::kernel,
    deploy_ramdisk => $::openstack::ironic::ramdisk,
  }
}
