# The profile for installing the Cinder API
class openstack::profile::cinder::api {

  openstack::resources::controller { 'cinder': }
  openstack::resources::database { 'cinder': }
  openstack::resources::firewall { 'Cinder API': port => '8776', }

  class { '::cinder::keystone::auth':
    password          => $::openstack::config::cinder_password,
    password_user_v2  => $::openstack::config::cinder_password,
    password_user_v3  => $::openstack::config::cinder_password,
    configure_user    => true,
    configure_user_v2 => true,
    configure_user_v3 => true,
    public_url        => "http://$::openstack::config::controller_address_api:8776/v1/%(tenant_id)s",
    admin_url         => "http://$::openstack::config::controller_address_management:8776/v1/%(tenant_id)s",
    internal_url      => "http://$::openstack::config::controller_address_management:8776/v1/%(tenant_id)s",
    public_url_v2     => "http://$::openstack::config::controller_address_api:8776/v2/%(tenant_id)s",
    admin_url_v2      => "http://$::openstack::config::controller_address_management:8776/v2/%(tenant_id)s",
    internal_url_v2   => "http://$::openstack::config::controller_address_management:8776/v2/%(tenant_id)s",
    public_url_v3     => "http://$::openstack::config::controller_address_api:8776/v3/%(tenant_id)s",
    admin_url_v3      => "http://$::openstack::config::controller_address_management:8776/v3/%(tenant_id)s",
    internal_url_v3   => "http://$::openstack::config::controller_address_management:8776/v3/%(tenant_id)s",
    region            => $::openstack::config::region,
  }

  include ::openstack::common::cinder

  class { '::cinder::api':
    keystone_password => $::openstack::config::cinder_password,
    auth_uri          => "http://$::openstack::config::controller_address_management:5000/",
    identity_uri      => "http://$::openstack::config::controller_address_management:35357/",
    keystone_tenant   => 'services',
    keystone_user     => 'cinder',
    os_region_name    => $::openstack::config::region,
    enabled           => true,
  }

  class { '::cinder::scheduler':
    scheduler_driver => 'cinder.scheduler.filter_scheduler.FilterScheduler',
    enabled          => true,
  }
}
