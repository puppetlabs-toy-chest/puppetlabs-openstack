# The puppet module to set up a Nova Compute node
class havana::profile::nova::compute {
  $management_network = hiera('havana::network::management')
  $management_address = ip_for_network($management_network)

  class { 'havana::common::nova':
    is_compute => true,
  }

  class { '::nova::compute::libvirt':
    libvirt_type     => hiera('havana::nova::libvirt_type'),
    vncserver_listen => $management_address,
  }

  # This may only be necessary for RHEL family systems
    file { '/etc/libvirt/qemu.conf':
      ensure => present,
      source => 'puppet:///modules/havana/qemu.conf',
      mode   => '0644',
      notify => Service['libvirt'],
    }
    Package['libvirt'] -> File['/etc/libvirt/qemu.conf']

  # clear the libvirtd masquerade rule
  if $::osfamily == 'RedHat' {
    # because firewall is not compatible with libvirtd, we need to flush
    # and update rules and services

    # exec rules for stopping libvirtd
    exec { '/sbin/service libvirtd stop':
      notify  => Service['libvirt'],
      returns => [0, 1],
    }

    exec { '/sbin/iptables -t nat -F POSTROUTING': }

    Exec['/sbin/service libvirtd stop'] ->
    Exec['/sbin/iptables -t nat -F POSTROUTING'] ->
    Class['::firewall']
    Firewall['9999 - Reject remaining traffic'] -> Service['libvirt']
  }
}
