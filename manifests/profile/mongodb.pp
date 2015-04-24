# The profile to install an OpenStack specific MongoDB server
class openstack::profile::mongodb {
  $management_network = $::openstack::network_management
  $inferred_address = ip_for_network($management_network)
  $explicit_address = $::openstack::controller_address_management

  if $inferred_address != $explicit_address {
    fail("MongoDB setup failed. The inferred location of the database based on the
    openstack::network::management hiera value is ${inferred_address}. The
    explicit address from openstack::controller::address::management
    is ${explicit_address}. Please correct this difference.")
  }

  class { '::mongodb::globals':
    manage_package_repo => true,
  }

  class { '::mongodb::server':
    bind_ip => ['127.0.0.1', $::openstack::controller_address_management],
  }

  class { '::mongodb::client': }
}
