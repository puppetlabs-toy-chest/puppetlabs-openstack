# The puppet module to set up a Nova Compute node
class openstack::profile::nova::compute {
  $management_network            = $::openstack::config::network_management
  $management_address            = ip_for_network($management_network)
  $controller_management_address = $::openstack::config::controller_address_management

  openstack::resources::firewall { 'Nova API': port => '8774', }
  openstack::resources::firewall { 'Nova Metadata': port => '8775', }

  include ::openstack::common::nova

  class { '::nova::compute':
    enabled                       => true,
    vnc_enabled                   => true,
    vncserver_proxyclient_address => $management_address[0],
    vncproxy_host                 => $::openstack::config::controller_address_api,
  }

  class { '::nova::api':
    admin_password                       => $::openstack::config::nova_password,
    auth_host                            => $controller_management_address,
    neutron_metadata_proxy_shared_secret => $::openstack::config::neutron_shared_secret,
  }

  if !defined(Service['openstack-nova-metadata-api']) {
    service { 'openstack-nova-metadata-api':
      ensure  => running,
      enable  => true,
      require => Class['::nova::api'],
    }
  }

  class { '::nova::compute::libvirt':
    libvirt_virt_type => $::openstack::config::nova_libvirt_type,
    vncserver_listen  => $management_address[0],
  }

  class { 'nova::migration::libvirt':
  }

  file { '/etc/libvirt/qemu.conf':
    ensure => present,
    source => 'puppet:///modules/openstack/qemu.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['libvirt'],
  }

  if $::osfamily == 'RedHat' {
    package { 'device-mapper':
      ensure => latest
    }
    Package['device-mapper'] ~> Service['libvirtd'] ~> Service['nova-compute']
  }
  Package['libvirt'] -> File['/etc/libvirt/qemu.conf']
}
