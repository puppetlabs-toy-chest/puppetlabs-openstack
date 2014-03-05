# The profile to set up the Nova controller (several services)
class havana::profile::nova::api {
  havana::resources::controller { 'nova': }
  havana::resources::database { 'nova': }
  havana::resources::firewall { 'Nova API': port => '8774', }
  havana::resources::firewall { 'Nova Metadata': port => '8775', }
  havana::resources::firewall { 'Nova NoVncProxy': port => '6080', }

  class { '::nova::keystone::auth':
    password         => hiera('havana::nova::password'),
    public_address   => hiera('havana::controller::address::api'),
    admin_address    => hiera('havana::controller::address::management'),
    internal_address => hiera('havana::controller::address::management'),
    region           => hiera('havana::region'),
    cinder           => true,
  }

  include ::havana::common::nova
}

