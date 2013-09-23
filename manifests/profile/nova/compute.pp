# The puppet module to set up a Nova Compute node
class grizzly::profile::nova::compute {

  $controller_address = hiera('grizzly::controller::address::management')
  $storage_address = hiera('grizzly::storage::address::management')

  $api_device = hiera('grizzly::network::api::device')
  $api_address = getvar("ipaddress_${api_device}")

  $management_device = hiera('grizzly::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")


  $data_device = hiera('grizzly::network::data::device')
  $data_address = getvar("ipaddress_${data_device}")

  $sql_password = hiera('grizzly::nova::sql::password')
  $sql_connection = "mysql://nova:${sql_password}@${management_address}/nova"

  class { 'grizzly::profile::nova::common':
    is_compute => true,
  }

  # This may only be necessary for RHEL family systems
  file { '/etc/libvirt/qemu.conf':
    ensure => present,
    source => 'puppet:///grizzly/qemu.conf',
    mode   => '0644',
    notify => Service['libvirtd'],
  }

}
