# The puppet module to set up a Nova Compute node
class openstack::profile::nova::compute {
  $management_network            = $::openstack::config::network_management
  $management_address            = ip_for_network($management_network)
  $controller_management_address = $::openstack::config::controller_address_management

  include ::openstack::common::nova

  class { '::nova::compute':
    enabled                       => true,
    vnc_enabled                   => true,
    vncserver_proxyclient_address => $management_address,
    vncproxy_host                 => $::openstack::config::controller_address_api,
  }

  class { '::nova::compute::libvirt':
    libvirt_virt_type => $::openstack::config::nova_libvirt_type,
    vncserver_listen  => $management_address,
  }

  class { 'nova::migration::libvirt':
  }

  class { '::nova::compute::rbd':
    libvirt_rbd_user        => $::openstack::config::libvirt_rbd_user,
    libvirt_rbd_secret_uuid => $::openstack::config::libvirt_rbd_secret_uuid,
    libvirt_rbd_secret_key  => $::openstack::config::libvirt_rbd_secret_key,
    libvirt_images_rbd_pool => $::openstack::config::libvirt_images_rbd_pool,
    rbd_keyring             => $::openstack::config::rbd_keyring,
    ephemeral_storage       => $::openstack::config::ephemeral_storage,
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
