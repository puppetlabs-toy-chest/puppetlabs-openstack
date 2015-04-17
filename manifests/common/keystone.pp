class openstack::common::keystone {
  if $::openstack::profile::base::is_controller {
    $admin_bind_host = '0.0.0.0'
    if $::openstack::keystone_use_httpd == true {
      $service_name = 'httpd'
    } else {
      $service_name = undef
    }
  } else {
    $admin_bind_host = $::openstack::controller_address_management
    $service_name    = undef
  }

  class { '::keystone':
    admin_token         => $::openstack::keystone_admin_token,
    database_connection => $::openstack::resources::connectors::keystone,
    verbose             => $::openstack::verbose,
    debug               => $::openstack::debug,
    enabled             => $::openstack::profile::base::is_controller,
    admin_bind_host     => $admin_bind_host,
    mysql_module        => '2.2',
    service_name        => $service_name,
  }

  class { '::keystone::roles::admin':
    email        => $::openstack::keystone_admin_email,
    password     => $::openstack::keystone_admin_password,
    admin_tenant => 'admin',
  }

}
