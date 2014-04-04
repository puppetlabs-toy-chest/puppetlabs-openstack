class openstack::profile::firewall::puppet {
  openstack::resources::firewall { 'Puppet': port => '8140' }
  openstack::resources::firewall { 'Puppet Orchestration': port => '61613' }
  openstack::resources::firewall { 'Puppet Console': port => '443' }
}
