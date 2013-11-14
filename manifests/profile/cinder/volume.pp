# The profile to install the volume service
class havana::profile::cinder::volume {

  firewall { '03260 - iscsi API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '3260',
  }

  include '::havana::profile::cinder::common'
  class { '::cinder::setup_test_volume': 
    volume_name => 'cinder-volumes',
    size        => hiera('havana::cinder::volume_size')
  } ->

  class { '::cinder::volume':
    package_ensure => true,
    enabled        => true,
  }

  class { '::cinder::volume::iscsi':
    iscsi_ip_address  => hiera('havana::storage::address::management'),
    volume_group      => 'cinder-volumes',
  }
}
