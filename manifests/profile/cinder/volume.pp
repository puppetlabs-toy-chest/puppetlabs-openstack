# The profile to install the volume service
class grizzly::profile::cinder::volume {

  firewall { '03260 - iscsi API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '3260',
  }

  include '::grizzly::profile::cinder::common'
  class { '::cinder::setup_test_volume': 
    volume_name => 'cinder-volumes',
    size        => hiera('grizzly::cinder::volume_size')
  } ->

  class { '::cinder::volume':
    package_ensure => true,
    enabled        => true,
  }

  class { '::cinder::volume::iscsi':
    iscsi_ip_address  => hiera('grizzly::storage::address::management'),
    volume_group      => 'cinder-volumes',
  }
}
