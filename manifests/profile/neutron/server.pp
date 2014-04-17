# The profile to set up the neutron server
class openstack::profile::neutron::server {
  openstack::resources::controller { 'neutron': }
  openstack::resources::database { 'neutron': } 
  openstack::resources::firewall { 'Neutron API': port => '9696', }

  include ::openstack::common::neutron
  include ::openstack::common::ovs

  Class['::neutron::db::mysql'] -> Exec['neutron-db-sync']
}
