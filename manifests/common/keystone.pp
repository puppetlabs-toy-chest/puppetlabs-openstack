class openstack::common::keystone {
  if $::openstack::profile::base::is_controller {
    $admin_bind_host = '0.0.0.0'
  } else {
    $admin_bind_host = hiera('openstack::controller::address::management')
  }

  class { '::keystone':
    admin_token     => hiera('openstack::keystone::admin_token'),
    sql_connection  => $::openstack::resources::connectors::keystone,
    verbose         => hiera('openstack::verbose'),
    debug           => hiera('openstack::debug'),
    enabled         => $::openstack::profile::base::is_controller,
    admin_bind_host => $admin_bind_host,
    mysql_module    => '2.2',
  }

  class { '::keystone::roles::admin':
    email        => hiera('openstack::keystone::admin_email'),
    password     => hiera('openstack::keystone::admin_password'),
    admin_tenant => 'admin',
  }
}
