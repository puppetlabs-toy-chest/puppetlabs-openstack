# The profile for installing the Cinder API
class havana::profile::cinder::api {

  havana::resources::controller { 'cinder': }
  havana::resources::database { 'cinder': }
  havana::resources::firewall { 'Cinder API': port => '8776', }

  class { '::cinder::keystone::auth':
    password         => hiera('havana::cinder::password'),
    public_address   => hiera('havana::controller::address::api'),
    admin_address    => hiera('havana::controller::address::management'),
    internal_address => hiera('havana::controller::address::management'),
    region           => hiera('havana::region'),
  }

  include '::havana::profile::cinder::common'

  class { '::cinder::api':
    keystone_password  => hiera('havana::cinder::password'),
    keystone_auth_host => hiera('havana::controller::address::management'),
    enabled            => true,
  }

  class { '::cinder::scheduler':
    scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
    enabled          => true,
  }
}
