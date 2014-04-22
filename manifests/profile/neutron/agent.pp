# The profile to set up a neutron agent
class havana::profile::neutron::agent {
  include ::havana::common::neutron
  include ::havana::common::ovs
}
