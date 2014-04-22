# The profile to set up the neutron server
class havana::profile::neutron::server {
  ::havana::resources::controller { 'neutron': }
  ::havana::resources::database { 'neutron': } 
  ::havana::resources::firewall { 'Neutron API': port => '9696', }

  include ::havana::common::neutron
  include ::havana::common::ovs

  Class['::neutron::db::mysql'] -> Exec['neutron-db-sync']
}
