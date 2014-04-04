# The profile for installing the Cinder API
class openstack::profile::cinder::api {

  openstack::resources::controller { 'cinder': }
  openstack::resources::database { 'cinder': }
  openstack::resources::firewall { 'Cinder API': port => '8776', }

  class { '::cinder::keystone::auth':
    password         => hiera('openstack::cinder::password'),
    public_address   => hiera('openstack::controller::address::api'),
    admin_address    => hiera('openstack::controller::address::management'),
    internal_address => hiera('openstack::controller::address::management'),
    region           => hiera('openstack::region'),
  }

  include ::openstack::common::cinder

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
