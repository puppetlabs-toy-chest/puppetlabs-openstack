# The profile to set up a neutron agent
class openstack::profile::neutron::agent {
  include ::openstack::common::neutron

  case $::openstack::config::neutron_core_plugin {
    'plumgrid': { include ::openstack::common::plumgrid }
    default:    { include ::openstack::common::ml2::ovs }
  }

}
