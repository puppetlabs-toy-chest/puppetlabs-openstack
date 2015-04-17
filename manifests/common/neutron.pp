# Common class for neutron installation
# Private, and should not be used on its own
# Sets up configuration common to all neutron nodes.
# Flags install individual services as needed
# This follows the suggest deployment from the neutron Administrator Guide.
class openstack::common::neutron {
  $is_controller = $::openstack::profile::base::is_controller

  $controller_management_address = $::openstack::controller_address_management

  $data_network = $::openstack::network_data
  $data_address = ip_for_network($data_network)

  # neutron auth depends upon a keystone configuration
  include ::openstack::common::keystone

  class { '::neutron':
    rabbit_host           => $controller_management_address,
    core_plugin           => $::openstack::neutron_core_plugin,
    allow_overlapping_ips => true,
    rabbit_user           => $::openstack::rabbitmq_user,
    rabbit_password       => $::openstack::rabbitmq_password,
    rabbit_hosts          => $::openstack::rabbitmq_hosts,
    debug                 => $::openstack::debug,
    verbose               => $::openstack::verbose,
    service_plugins       => $::openstack::neutron_service_plugins,
  }

  class { '::neutron::keystone::auth':
    password         => $::openstack::neutron_password,
    public_address   => $::openstack::controller_address_api,
    admin_address    => $::openstack::controller_address_management,
    internal_address => $::openstack::controller_address_management,
    region           => $::openstack::region,
  }

  class { '::neutron::server':
    auth_host           => $::openstack::controller_address_management,
    auth_password       => $::openstack::neutron_password,
    database_connection => $::openstack::resources::connectors::neutron,
    enabled             => $is_controller,
    sync_db             => $is_controller,
    mysql_module        => '2.2',
  }

  if $is_controller {
    anchor { 'neutron_common_first': } ->
      class { '::neutron::server::notifications':
        nova_url            => "http://${controller_management_address}:8774/v2/",
        nova_admin_auth_url => "http://${controller_management_address}:35357/v2.0/",
        nova_admin_password => $::openstack::nova_password,
        nova_region_name    => $::openstack::region,
      }
    anchor { 'neutron_common_last': }
  }

  if $::osfamily == 'redhat' {
    package { 'iproute':
        ensure => latest,
        before => Class['::neutron']
    }
  }
}
