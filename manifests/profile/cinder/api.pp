# The profile for installing the Cinder API
class openstack::profile::cinder::api {

  openstack::resources::controller { 'cinder': }
  openstack::resources::database { 'cinder': }
  openstack::resources::firewall { 'Cinder API': port => '8776', }

  class { '::cinder::keystone::auth':
    password         => $::openstack::cinder_password,
    public_address   => $::openstack::controller_address_api,
    admin_address    => $::openstack::controller_address_management,
    internal_address => $::openstack::controller_address_management,
    region           => $::openstack::region,
  }

  include ::openstack::common::cinder

  class { '::cinder::api':
    keystone_password  => $::openstack::cinder_password,
    keystone_auth_host => $::openstack::controller_address_management,
    enabled            => true,
  }

  class { '::cinder::scheduler':
    scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
    enabled          => true,
  }
}
