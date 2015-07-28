# The profile to set up the neutron server
class openstack::profile::neutron::server {

  openstack::resources::database { 'neutron': }
  openstack::resources::firewall { 'Neutron API': port => '9696', }

  include ::openstack::common::neutron

  $tenant_network_type           = $::openstack::config::neutron_tenant_network_type # ['gre']
  $type_drivers                  = $::openstack::config::neutron_type_drivers # ['gre']
  $mechanism_drivers             = $::openstack::config::neutron_mechanism_drivers # ['openvswitch']
  $tunnel_id_ranges              = $::openstack::config::neutron_tunnel_id_ranges # ['1:1000']
  $controller_management_address = $::openstack::config::controller_address_management

  if ($::openstack::config::neutron_core_plugin == 'ml2') {
    class  { '::neutron::plugins::ml2':
      type_drivers         => $type_drivers,
      tenant_network_types => $tenant_network_type,
      mechanism_drivers    => $mechanism_drivers,
      tunnel_id_ranges     => $tunnel_id_ranges
    }
  } elsif ($::openstack::config::neutron_core_plugin == 'plumgrid') {
    $user = $::openstack::config::mysql_user_neutron
    $pass = $::openstack::config::mysql_pass_neutron
    $db_connection = "mysql://${user}:${pass}@${controller_management_address}/neutron"

    if !defined(Package['python-pip']) {
      package { 'python-pip': ensure => present, }
    }

    neutron_config {
      'DEFAULT/service_plugins': ensure => absent,
    }
    ->
    class { '::neutron::plugins::plumgrid':
      director_server              => $::openstack::config::plumgrid_director_vip,
      username                     => $::openstack::config::plumgrid_username,
      password                     => $::openstack::config::plumgrid_password,
      admin_password               => $::openstack::config::keystone_admin_password,
      controller_priv_host         => $controller_management_address,
      connection                   => $db_connection,
      nova_metadata_ip             => $::openstack::config::plumgrid_nova_metadata_ip,
      nova_metadata_port           => $::openstack::config::plumgrid_nova_metadata_port,
      metadata_proxy_shared_secret => $::openstack::config::neutron_shared_secret,
    }
    ->
    package { 'networking-plumgrid':
      ensure   => present,
      provider => 'pip',
      notify   => Service["$::neutron::params::server_service"],
      require  => Package['python-pip'],
    }
  }

  anchor { 'neutron_common_first': } ->
  class { '::neutron::server::notifications':
    nova_url            => "http://${controller_management_address}:8774/v2/",
    nova_admin_auth_url => "http://${controller_management_address}:35357/v2.0/",
    nova_admin_password => $::openstack::config::nova_password,
    nova_region_name    => $::openstack::config::region,
  } ->
  anchor { 'neutron_common_last': }

  Class['::neutron::db::mysql'] -> Exec['neutron-db-sync']
}
