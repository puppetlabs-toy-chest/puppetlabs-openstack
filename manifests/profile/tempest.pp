# Profile to install the tempest service
class openstack::profile::tempest {
  $users      = hiera('openstack::keystone::users')
  $api_ip     = $::openstack::config::controller_address_api
  $admin_user = $::openstack::config::tempest_username_admin
  $user       = $::openstack::config::tempest_username
  $alt_user   = $::openstack::config::tempest_username_alt
  $public_network_name = $::openstack::config::tempest_public_network_name

  include ::openstack::common::keystone
  include ::openstack::common::glance
  include ::openstack::common::neutron

  class { '::tempest':
    setup_venv             => true,
    tempest_repo_revision  => 'master',
    cinder_available       => $::openstack::config::tempest_cinder_available,
    glance_available       => $::openstack::config::tempest_glance_available,
    heat_available         => $::openstack::config::tempest_heat_available,
    horizon_available      => $::openstack::config::tempest_horizon_available,
    neutron_available      => $::openstack::config::tempest_neutron_available,
    nova_available         => $::openstack::config::tempest_nova_available,
    swift_available        => $::openstack::config::tempest_swift_available,
    configure_images       => $::openstack::config::tempest_configure_images,
    image_name             => $::openstack::config::tempest_image_name,
    image_name_alt         => $::openstack::config::tempest_image_name_alt,
    configure_networks     => $::openstack::config::tempest_configure_network,
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
