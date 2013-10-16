# The profile to install an OpenStack specific mysql server
class grizzly::profile::auth_file {
  class { '::openstack::auth_file':
    admin_password  => hiera('grizzly::keystone::admin_password'),
    region_name     => hiera('grizzly::region'),
    controller_node => hiera('grizzly::controller::address::api'),
  }
}
