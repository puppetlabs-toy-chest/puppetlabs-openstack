# The profile to set up a neutron agent
class openstack::profile::neutron::agent {
  include ::openstack::common::neutron
  include ::openstack::common::ml2::ovs
}
