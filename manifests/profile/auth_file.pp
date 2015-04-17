# The profile to install an OpenStack specific mysql server
class openstack::profile::auth_file {
  class { '::openstack::resources::auth_file':
    admin_tenant    => 'admin',
    admin_password  => $::openstack::keystone_admin_password,
    region_name     => $::openstack::region,
    controller_node => $::openstack::controller_address_api,
  }
}
