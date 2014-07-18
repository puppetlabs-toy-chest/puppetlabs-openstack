# The profile to install the volume service
class openstack::profile::cinder::volume {
  $management_network = $::openstack::config::network_management
  $management_address = ip_for_network($management_network)

  openstack::resources::firewall { 'ISCSI API': port => '3260', }

  include ::openstack::common::cinder

  class { '::cinder::setup_test_volume':
    volume_name => 'cinder-volumes',
    size        => $::openstack::config::cinder_volume_size
  } ->

  class { '::cinder::volume':
    package_ensure => true,
    enabled        => true,
  }

  class { '::cinder::volume::iscsi':
    iscsi_ip_address  => $management_address,
    volume_group      => 'cinder-volumes',
  }
}
