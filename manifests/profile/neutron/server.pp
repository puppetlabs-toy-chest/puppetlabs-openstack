# The profile to set up the neutron server
class openstack::profile::neutron::server {
  openstack::resources::controller { 'neutron': }
  openstack::resources::database { 'neutron': } 
  openstack::resources::firewall { 'Neutron API': port => '9696', }

  include ::openstack::common::neutron

  if $::openstack::config::enable_plumgrid {
    include ::openstack::common::plumgrid
  } else {
    include ::openstack::common::ovs
  }

  Class['::neutron::db::mysql'] -> Exec['neutron-db-sync']
}
