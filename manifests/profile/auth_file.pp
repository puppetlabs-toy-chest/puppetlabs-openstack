# The profile to install an OpenStack specific mysql server
class havana::profile::auth_file {
  class { '::havana::resources::auth_file':
    admin_tenant    => 'admin',
    admin_password  => hiera('openstack::keystone::admin_password'),
    region_name     => hiera('openstack::region'),
    controller_node => hiera('openstack::controller::address::api'),
  }
}
