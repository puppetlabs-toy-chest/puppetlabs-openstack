class openstack::common::keystone {
  if $::openstack::profile::base::is_controller {
    $admin_bind_host = '0.0.0.0'
    if $::openstack::config::keystone_use_httpd == true {
      $service_name = 'httpd'
    } else {
      $service_name = undef
    }
  } else {
    $admin_bind_host = $::openstack::config::controller_address_management
    $service_name    = undef
  }

  class { '::keystone':
    admin_token         => $::openstack::config::keystone_admin_token,
    database_connection => $::openstack::resources::connectors::keystone,
    verbose             => $::openstack::config::verbose,
    debug               => $::openstack::config::debug,
    enabled             => $::openstack::profile::base::is_controller,
    admin_bind_host     => $admin_bind_host,
    mysql_module        => '2.2',
    service_name        => $service_name,
  }

  class { '::keystone::roles::admin':
    email        => $::openstack::config::keystone_admin_email,
    password     => $::openstack::config::keystone_admin_password,
    admin_tenant => 'admin',
  }

}
