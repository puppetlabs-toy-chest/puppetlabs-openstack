# post-firewall rules to reject remaining traffic
class havana::profile::firewall::post {
  firewall { '99998 - Accept all management network traffic':
    proto  => 'all',
    action => 'accept',
    source => hiera('havana::network::management'),
    before => [ Firewall['99999 - Reject remaining traffic'] ],
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
