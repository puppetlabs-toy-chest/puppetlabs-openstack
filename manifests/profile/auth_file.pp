# The profile to install an OpenStack specific mysql server
class openstack::profile::auth_file {
  class { '::openstack_extras::auth_file':
    tenant_name => 'admin',
    password    => $::openstack::config::keystone_admin_password,
    auth_url    => "http://${::openstack::config::controller_address_api}:5000/v2.0/",
    region_name => $::openstack::config::region,
  }
}
