# The profile for installing the Cinder API
class havana::profile::cinder::api {

  ::havana::resources::controller { 'cinder': }
  ::havana::resources::database { 'cinder': }
  ::havana::resources::firewall { 'Cinder API': port => '8776', }

  class { '::cinder::keystone::auth':
    password         => hiera('openstack::cinder::password'),
    public_address   => hiera('openstack::controller::address::api'),
    admin_address    => hiera('openstack::controller::address::management'),
    internal_address => hiera('openstack::controller::address::management'),
    region           => hiera('openstack::region'),
  }

  include ::havana::common::cinder

  class { '::cinder::api':
    keystone_password  => hiera('openstack::cinder::password'),
    keystone_auth_host => hiera('openstack::controller::address::management'),
    enabled            => true,
  }

  class { '::cinder::scheduler':
    scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
    enabled          => true,
  }
}
