# The profile to set up a neutron agent
class openstack::profile::neutron::agent {
  include ::openstack::common::neutron

  case $::openstack::config::neutron_core_plugin {
    'plumgrid': { include ::openstack::common::plumgrid }
    default:    { include ::openstack::common::ml2::ovs }
  }

  ### Router service installation
  class { '::neutron::agents::l3':
    debug                    => $::openstack::config::debug,
    external_network_bridge  => 'brex',
    enabled                  => true,
    agent_mode               => 'dvr',
    router_delete_namespaces => 'True',
  }

  $external_bridge = 'brex'
  $external_network = $::openstack::config::network_external
  $external_device = device_for_network($external_network)
  vs_bridge { $external_bridge:
    ensure => present,
  }
  if $external_device != $external_bridge {
    vs_port { $external_device:
      ensure => present,
      bridge => $external_bridge,
    }
  } else {
    # External bridge already has the external device's IP, thus the external
    # device has already been linked
  }
}
