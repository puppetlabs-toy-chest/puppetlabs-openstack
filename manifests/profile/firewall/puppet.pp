class havana::profile::firewall::puppet {
  ::havana::resources::firewall { 'Puppet': port => '8140' }
  ::havana::resources::firewall { 'Puppet Orchestration': port => '61613' }
  ::havana::resources::firewall { 'Puppet Console': port => '443' }
}
