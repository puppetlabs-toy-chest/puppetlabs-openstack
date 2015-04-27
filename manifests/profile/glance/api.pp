# The profile to install the Glance API and Registry services
# Note that for this configuration API controls the storage,
# so it is on the storage node instead of the control node
class openstack::profile::glance::api {
  $api_network = $::openstack::config::network_api
  $api_address = ip_for_network($api_network)

  $management_network = $::openstack::config::network_management
  $management_address = ip_for_network($management_network)

  $controller_address  = $::openstack::config::controller_address_management
  $user                = $::openstack::config::mysql_user_glance
  $pass                = $::openstack::config::mysql_pass_glance
  $database_connection = "mysql://${user}:${pass}@${controller_address}/glance"

  openstack::resources::firewall { 'Glance API': port      => '9292', }
  openstack::resources::firewall { 'Glance Registry': port => '9191', }

  class { '::glance::api':
    keystone_password   => $::openstack::config::glance_password,
    auth_host           => $::openstack::config::controller_address_management,
    keystone_tenant     => 'services',
    keystone_user       => 'glance',
    database_connection => $database_connection,
    registry_host       => $::openstack::config::storage_address_management,
    verbose             => $::openstack::config::verbose,
    debug               => $::openstack::config::debug,
    enabled             => $::openstack::profile::base::is_storage,
    os_region_name      => $::openstack::config::region,
  }

  class { '::glance::backend::file': }

  class { '::glance::registry':
    keystone_password   => $::openstack::config::glance_password,
    database_connection => $database_connection,
    auth_host           => $::openstack::config::controller_address_management,
    keystone_tenant     => 'services',
    keystone_user       => 'glance',
    verbose             => $::openstack::config::verbose,
    debug               => $::openstack::config::debug,
    mysql_module        => '2.2',
  }

  class { '::glance::notify::rabbitmq':
    rabbit_password => $::openstack::config::rabbitmq_password,
    rabbit_userid   => $::openstack::config::rabbitmq_user,
    rabbit_host     => $::openstack::config::controller_address_management,
  }

  $images = $::openstack::config::images

  create_resources('glance_image', $images)
}
