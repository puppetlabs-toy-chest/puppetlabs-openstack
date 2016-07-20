class openstack::common::keystone {
  if $::openstack::profile::base::is_controller {
    $admin_bind_host = '0.0.0.0'
  } else {
    $admin_bind_host = $::openstack::config::controller_address_management
  }

  #file { '/var/log/keystone/keystone.log':
  #  ensure => 'present',
  #  owner  => 'keystone',
  #  group  => 'keystone',
  #  mode   => '0664'
  #}
  #Package<||> -> File['/var/log/keystone/keystone.log'] -> Service['openstack-keystone'] 

  class { '::keystone':
    admin_token         => $::openstack::config::keystone_admin_token,
    database_connection => $::openstack::resources::connectors::keystone,
    debug               => $::openstack::config::debug,
    enabled             => $::openstack::profile::base::is_controller,
    admin_bind_host     => $admin_bind_host,
  }

  class { '::keystone::roles::admin':
    email        => $::openstack::config::keystone_admin_email,
    password     => $::openstack::config::keystone_admin_password,
    admin_tenant => 'admin',
  }
}
