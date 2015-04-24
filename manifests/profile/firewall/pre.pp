# Starts up standard firewall rules. Pre-runs

class openstack::profile::firewall::pre {

  # Set up the initial firewall rules for all nodes
  firewallchain { 'INPUT:filter:IPv4':
    purge  => true,
    ignore => ['neutron','virbr0'],
    before => Firewall['0001 - related established'],
  }

  include ::firewall

  # Default firewall rules, based on the RHEL defaults
  firewall { '0001 - related established':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
    before => [ Class['::firewall'] ],
  } ->
  firewall { '0002 - localhost':
    proto  => 'icmp',
    action => 'accept',
    source => '127.0.0.1',
  } ->
  firewall { '0003 - localhost':
    proto  => 'all',
    action => 'accept',
    source => '127.0.0.1',
  } ->
  firewall { '0022 - ssh':
    proto  => 'tcp',
    state  => ['NEW', 'ESTABLISHED', 'RELATED'],
    action => 'accept',
    port   => 22,
    before => [ Firewall['8999 - Accept all management network traffic'] ],
  }
}
