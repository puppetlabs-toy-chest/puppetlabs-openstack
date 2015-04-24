# The puppet module to set up a Nova Compute node
class openstack::profile::nova::compute {
  $management_network = $::openstack::network_management
  $management_address = ip_for_network($management_network)

  class { 'openstack::common::nova':
    is_compute => true,
  }

  class { '::nova::compute::libvirt':
    libvirt_virt_type => $::openstack::nova_libvirt_type,
    vncserver_listen  => $management_address,
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

  Package['libvirt'] -> File['/etc/libvirt/qemu.conf']
}
