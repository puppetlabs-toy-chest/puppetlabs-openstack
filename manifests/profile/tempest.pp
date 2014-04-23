# Profile to install the tempest service
class openstack::profile::tempest {
  $users      = hiera('openstack::users')
  $api_ip     = hiera('openstack::controller::address::api')
  $admin_user = hiera('openstack::tempest::username_admin')
  $user       = hiera('openstack::tempest::username')
  $alt_user   = hiera('openstack::tempest::username_alt')
  $public_network_name = hiera('openstack::tempest::public_network_name')

  include ::openstack::common::keystone
  include ::openstack::common::glance
  include ::openstack::common::neutron

  class { '::tempest':
    setup_venv             => true,
    tempest_repo_revision  => 'master',
    cinder_available       => hiera('openstack::tempest::cinder_available'),
    glance_available       => hiera('openstack::tempest::glance_available'),
    heat_available         => hiera('openstack::tempest::heat_available'),
    horizon_available      => hiera('openstack::tempest::horizon_available'),
    neutron_available      => hiera('openstack::tempest::neutron_available'),
    nova_available         => hiera('openstack::tempest::nova_available'),
    swift_available        => hiera('openstack::tempest::swift_available'),
    configure_images       => hiera('openstack::tempest::configure_images'),
    image_name             => hiera('openstack::tempest::image_name'),
    image_name_alt         => hiera('openstack::tempest::image_name_alt'),
    configure_networks     => hiera('openstack::tempest::configure_network'),
    public_network_name    => $public_network_name,
    identity_uri           => "http://${api_ip}:5000/v2.0/",
    admin_username         => $admin_user,
    admin_password         => $users[$admin_user]['password'],
    admin_tenant_name      => $users[$admin_user]['tenant'],
    username               => $user,
    password               => $users[$user]['password'],
    tenant_name            => $users[$user]['tenant'],
    alt_username           => $alt_user,
    alt_password           => $users[$alt_user]['password'],
    alt_tenant_name        => $users[$alt_user]['tenant'],
    allow_tenant_isolation => true,
    require                => Class['::neutron::keystone::auth'],
  }

  Tempest_config {
    path    => $::tempest::tempest_conf,
    require => File[$::tempest::tempest_conf],
  }

  tempest_config {
    'boto/ec2_url':            value => "http://${api_ip}:8773/services/Cloud";
    'boto/s3_url':             value => "http://${api_ip}:3333";
    'dashboard/dashboard_url': value => "http://${api_ip}/";
    'dashboard/login_url':     value => "http://${api_ip}/dashboard";
  }
}
