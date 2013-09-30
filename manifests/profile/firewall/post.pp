# post-firewall rules to reject remaining traffic
class grizzly::profile::firewall::post {

  firewall { '99998 - Accept all management network traffic':
    proto  => 'all',
    action => 'accept',
    source => hiera('grizzly::network::management'),
    before => undef,
  }

  #6    REJECT     all  --  0.0.0.0/0            0.0.0.0/0
  #reject-with icmp-host-prohibited
  firewall { '99999 - Reject remaining traffic':
    action => 'reject',
    proto  => 'all',
    reject => 'icmp-host-prohibited',
    source => '0.0.0.0/0',
  }
}
