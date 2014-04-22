# The profile to set up the Nova controller (several services)
class havana::profile::nova::api {
  ::havana::resources::controller { 'nova': }
  ::havana::resources::database { 'nova': }
  ::havana::resources::firewall { 'Nova API': port => '8774', }
  ::havana::resources::firewall { 'Nova Metadata': port => '8775', }
  ::havana::resources::firewall { 'Nova EC2': port => '8773', }
  ::havana::resources::firewall { 'Nova S3': port => '3333', }

  class { '::nova::keystone::auth':
    password         => hiera('openstack::nova::password'),
    public_address   => hiera('openstack::controller::address::api'),
    admin_address    => hiera('openstack::controller::address::management'),
    internal_address => hiera('openstack::controller::address::management'),
    region           => hiera('openstack::region'),
    cinder           => true,
  }

  include ::havana::common::nova
}
