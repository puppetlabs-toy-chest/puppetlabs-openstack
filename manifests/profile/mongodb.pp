# The profile to install an OpenStack specific MongoDB server
class openstack::profile::mongodb {
  $management_network = $::openstack::config::network_management

  class { '::mongodb::globals':
    manage_package_repo => true,
  }

  class { '::mongodb::server':
    bind_ip => ['127.0.0.1', $::openstack::config::controller_address_management],
  }

  class { '::mongodb::client': }
}
