# The profile to install the volume service
class grizzly::profile::cinder::volume {

  firewall { '03260 - iscsi API Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '3260',
    source => hiera('grizzly::network::api'),
  }

  firewall { '03260 - iscsi Management Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '3260',
    source => hiera('grizzly::network::management'),
  }

  class { 'grizzly::profile::cinder::common':
    is_volume => true,
  }
}
