# The profile to set up a neutron agent
class openstack::profile::neutron::agent {
  include ::openstack::common::neutron

  case $::openstack::config::neutron_core_plugin {
    'plumgrid': { include ::openstack::common::plumgrid }
    default:    { include ::openstack::common::ml2::ovs }
  include ::openstack::common::ml2::ovs

  ### Router service installation
  class { '::neutron::agents::l3':
    debug                    => $::openstack::config::debug,
    external_network_bridge  => 'brex',
    enabled                  => true,
    agent_mode               => 'dvr',
    router_delete_namespaces => 'True',
  }

}
