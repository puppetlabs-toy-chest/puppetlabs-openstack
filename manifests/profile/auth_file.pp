# The profile to install an OpenStack specific mysql server
class openstack::profile::auth_file {
  class { '::openstack_extras::auth_file':
    tenant_name    => 'openstack',
    password       => $::openstack::config::keystone_admin_password,
    auth_url       => "http://${::openstack::config::controller_address_api}:5000/v3/",
    region_name    => $::openstack::config::region,
    project_domain => 'default',
    user_domain    => 'default',
  }
}
