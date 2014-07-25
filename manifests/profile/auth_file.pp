# The profile to install an OpenStack specific mysql server
class openstack::profile::auth_file {
  class { '::openstack::resources::auth_file':
    admin_tenant    => 'admin',
    admin_password  => $::openstack::config::keystone_admin_password,
    region_name     => $::openstack::config::region,
    controller_node => $::openstack::config::controller_address_api,
  }
}
