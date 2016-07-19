class openstack::common::keystone {
  if $::openstack::profile::base::is_controller {
    $admin_bind_host = '0.0.0.0'
  } else {
    $admin_bind_host = $::openstack::config::controller_address_management
  }

  file { '/etc/keystone/fernet-keys':
    ensure => 'directory',
    owner  => 'root',
    group  => 'keystone',
    mode   => '0770',
  }

  class { '::keystone':
    admin_token         => $::openstack::config::keystone_admin_token,
    database_connection => $::openstack::resources::connectors::keystone,
    debug               => $::openstack::config::debug,
    enabled             => $::openstack::profile::base::is_controller,
    admin_bind_host     => $admin_bind_host,
    enable_fernet_setup => true,
    token_provider      => 'fernet',
  }

  class { '::keystone::roles::admin':
    email        => $::openstack::config::keystone_admin_email,
    password     => $::openstack::config::keystone_admin_password,
    admin_tenant => 'admin',
  }
}
