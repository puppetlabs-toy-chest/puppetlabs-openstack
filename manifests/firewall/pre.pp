# Starts up standard firewall rules. Pre-runs

class grizzly::firewall::pre {
  resources { "firewall":
    purge => true,
  }

  Firewall {
    require => undef,
  }

  # Default firewall rules, based on the RHEL defaults
  #Table: filter
  #Chain INPUT (policy ACCEPT)
  #num  target     prot opt source               destination
  #1    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0
  # state RELATED,ESTABLISHED
  firewall { '00001 - related established':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  } ->
  #2    ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0
  firewall { '00002 - localhost':
    proto  => 'icmp',
    action => 'accept',
    source => '127.0.0.1',
  } ->
  #3    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0
  firewall { '00003 - localhost':
    proto  => 'all',
    action => 'accept',
    source => '127.0.0.1',
  } ->
  #4    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0
  # state NEW tcp dpt:22
  firewall { '00022 - ssh':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => 22,
  }
}
