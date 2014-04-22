# Common class for neutron installation
# Private, and should not be used on its own
# Sets up configuration common to all neutron nodes.
# Flags install individual services as needed
# This follows the suggest deployment from the neutron Administrator Guide.
class havana::common::neutron {
  $controller_management_address = hiera('openstack::controller::address::management')

  $data_network = hiera('openstack::network::data')
  $data_address = ip_for_network($data_network)

  # neutron auth depends upon a keystone configuration
  include ::havana::common::keystone

  class { '::neutron':
    rabbit_host           => $controller_management_address,
    core_plugin           => 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2',
    allow_overlapping_ips => true,
    rabbit_user           => hiera('openstack::rabbitmq::user'),
    rabbit_password       => hiera('openstack::rabbitmq::password'),
    debug                 => hiera('openstack::debug'),
    verbose               => hiera('openstack::verbose'),
    service_plugins       => ['neutron.services.loadbalancer.plugin.LoadBalancerPlugin',
                              'neutron.services.vpn.plugin.VPNDriverPlugin'],
  }

  class { '::neutron::keystone::auth':
    password         => hiera('openstack::neutron::password'),
    public_address   => hiera('openstack::controller::address::api'),
    admin_address    => hiera('openstack::controller::address::management'),
    internal_address => hiera('openstack::controller::address::management'),
    region           => hiera('openstack::region'),
  }

  class { '::neutron::server':
    auth_host           => hiera('openstack::controller::address::management'),
    auth_password       => hiera('openstack::neutron::password'),
    database_connection => $::havana::resources::connectors::neutron,
    enabled             => $::havana::profile::base::is_controller,
    sync_db             => $::havana::profile::base::is_controller,
  }

  if $::osfamily == 'redhat' {
    package { 'iproute':
        ensure => latest,
        before => Class['::neutron']
    }
  }
}
