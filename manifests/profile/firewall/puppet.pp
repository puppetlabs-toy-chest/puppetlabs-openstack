class havana::profile::firewall::puppet {
  firewall { '08140 - Puppet':
    proto  => 'tcp',
    state  => ['NEW', 'ESTABLISHED', 'RELATED'],
    action => 'accept',
    port   => '8140',
  }

  firewall { '61613 - Puppet Orchestration':
    proto  => 'tcp',
    state  => ['NEW', 'ESTABLISHED', 'RELATED'],
    action => 'accept',
    port   => '61613',
  }
  
  firewall { '00443 - Puppet Console':
    proto  => 'tcp',
    state  => ['NEW', 'ESTABLISHED', 'RELATED'],
    action => 'accept',
    port   => '443',
  } 
}
