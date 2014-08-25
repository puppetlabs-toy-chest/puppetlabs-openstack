# The profile to set up a neutron agent
class openstack::profile::neutron::agent {
  include ::openstack::common::neutron

  if $::openstack::config::enable_plumgrid {
    include ::openstack::common::plumgrid
  } else {
    include ::openstack::common::ovs
  }
}
