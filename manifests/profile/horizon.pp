class grizzly::profile::horizon {
  class { '::horizon':
    secret_key => hiera('grizzly::horizon::secret_key'),
  }

  # public API access
  firewall { '00080 - Apache (Horizon)':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '80',
    source => hiera('grizzly::network::api')
  } 

  # public API access
  firewall { '00443 - Apache SSL (Horizon)':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '443',
    source => hiera('grizzly::network::api')
  } 

  if $::selinux and $::selinux != 'false' {
    selboolean{'httpd_can_network_connect':
      value      => on,
      persistent => true,
    }
  }

}
