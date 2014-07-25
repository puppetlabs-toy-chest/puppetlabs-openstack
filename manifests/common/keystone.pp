class openstack::common::keystone {
  if $::openstack::profile::base::is_controller {
    $admin_bind_host = '0.0.0.0'
  } else {
    $admin_bind_host = $::openstack::config::controller_address_management
  }

  class { '::keystone':
    admin_token     => $::openstack::config::keystone_admin_token,
    sql_connection  => $::openstack::resources::connectors::keystone,
    verbose         => $::openstack::config::verbose,
    debug           => $::openstack::config::debug,
    enabled         => $::openstack::profile::base::is_controller,
    admin_bind_host => $admin_bind_host,
    mysql_module    => '2.2',
  }

  class { '::keystone::roles::admin':
    email        => $::openstack::config::keystone_admin_email,
    password     => $::openstack::config::keystone_admin_password,
    admin_tenant => 'admin',
  }
}
