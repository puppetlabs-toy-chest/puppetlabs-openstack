# The puppet module to set up a Nova Compute node
class havana::profile::nova::compute {
  $management_network = hiera('openstack::network::management')
  $management_address = ip_for_network($management_network)

  class { 'openstack::common::nova':
    is_compute => true,
  }

  class { '::nova::compute::libvirt':
    libvirt_type     => hiera('openstack::nova::libvirt_type'),
    vncserver_listen => $management_address,
  }

  file { '/etc/libvirt/qemu.conf':
    ensure => present,
    source => 'puppet:///modules/openstack/qemu.conf',
    mode   => '0644',
    notify => Service['libvirt'],
  }

  Package['libvirt'] -> File['/etc/libvirt/qemu.conf']
}
