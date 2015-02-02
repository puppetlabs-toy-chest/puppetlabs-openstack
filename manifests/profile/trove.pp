class openstack::profile::trove {
  openstack::resources::controller { 'trove': }
  openstack::resources::firewall { 'Trove API': port => '8779' }
  openstack::resources::database { 'trove': } 
  $controller_management_address = $::openstack::config::controller_address_management

  file { '/etc/trove/api-paste.ini':
    ensure  => link,
    target  => '/usr/share/trove/trove-dist-paste.ini',
    require => Package['openstack-trove-api'],
  }

  file { '/var/log/trove/trove-api.log':
    owner   => 'trove',
    group   => 'trove',
    ensure  => present,
    require => Package['openstack-trove-api'],
    before  => Service['openstack-trove-api'],
  }

  File['/etc/trove/api-paste.ini'] -> Trove_config<||>

  class { '::trove::keystone::auth':
    password         => $::openstack::config::trove_password,
    public_address   => $::openstack::config::controller_address_api,
    admin_address    => $::openstack::config::controller_address_management,
    internal_address => $::openstack::config::controller_address_management,
    region           => $::openstack::config::region,
  }

  package { 'python-pbr':
    ensure => present,
  } ->

  class { '::trove':
    database_connection   => $::openstack::resources::connectors::trove,
    rabbit_hosts          => [$controller_management_address],
    rabbit_userid         => $::openstack::config::rabbitmq_user,
    rabbit_password       => $::openstack::config::rabbitmq_password,
    nova_proxy_admin_pass => $::openstack::config::nova_password,
  }

  exec { 'trove-db-sync':
    command     => 'trove-manage --config-file /etc/trove/trove.conf db_sync',
    path        => '/usr/bin',
    before      => Service['trove-api'],
    require     => Trove_config['DEFAULT/sql_connection'],
    refreshonly => true,
  }

  trove_config { 'DEFAULT/api_paste_config':
    value =>  '/etc/trove/api-paste.ini',
  }

  class { '::trove::api':
    keystone_password => $::openstack::config::trove_password,
    auth_host         => $controller_management_address,
  }

  class { '::trove::conductor':
  }

  class { '::trove::taskmanager':
    auth_url => "http://${controller_management_address}:5000/v2.0",
  }

  trove_taskmanager_config { 'DEFAULT/os_region_name':
    value => $::openstack::config::region,
  }

  trove_taskmanager_config { 'DEFAULT/nova_compute_url':
    value => "http://${controller_management_address}:8774/v2",
  }
}
