# post-firewall rules to reject remaining traffic
class havana::profile::firewall::post {
  firewall { '8999 - Accept all management network traffic':
    proto  => 'all',
    state  => ['NEW'],
    action => 'accept',
    source => hiera('havana::network::management'),
  }  ->
  firewall { '9999 - Reject remaining traffic':
    proto  => 'all',
    action => 'reject',
    reject => 'icmp-host-prohibited',
    source => '0.0.0.0/0',
  }
}
