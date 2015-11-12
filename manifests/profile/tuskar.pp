class openstack::profile::tuskar {
  openstack::resources::controller { 'tuskar': }
  openstack::resources::firewall { 'Tuskar API': port => '8585' }
  openstack::resources::database { 'tuskar': }
  $controller_management_address = $::openstack::config::controller_address_management

  class { '::tuskar::client': }

  class { '::tuskar::keystone::auth':
    password         => $::openstack::config::ironic_password,
    public_address   => $::openstack::config::controller_address_api,
    admin_address    => $::openstack::config::controller_address_management,
    internal_address => $::openstack::config::controller_address_management,
    region           => $::openstack::config::region,
  }

  class { '::tuskar': 
    database_connection => $::openstack::resources::connectors::tuskar,
  }

  class { '::tuskar::api':
    keystone_password => $::openstack::config::tuskar_password,
    identity_uri      => "http://${controller_management_address}:35357",
    enabled           => $is_controller,
    require           => File['/var/log/tuskar']
  }

  file { '/var/log/tuskar':
    owner   => 'tuskar',
    group   => 'tuskar',
    ensure  => 'directory',
    require => Package[$tuskar::params::api_package_name]
  }

  class { '::tuskar::ui': }
}
