# Profile to install the tempest service
class havana::profile::tempest {
  $users      = hiera('havana::users')
  $api_ip     = hiera('havana::controller::address::api')
  $admin_user = hiera('havana::tempest::username_admin')
  $user       = hiera('havana::tempest::username')
  $alt_user   = hiera('havana::tempest::username_alt')
  $public_network_name = hiera('havana::tempest::public_network_name')

  class { '::tempest':
    setup_venv            => true,
    tempest_repo_revision => 'stable/havana',
    cinder_available      => hiera('havana::tempest::cinder_available'),
    glance_available      => hiera('havana::tempest::glance_available'),
    heat_available        => hiera('havana::tempest::heat_available'),
    horizon_available     => hiera('havana::tempest::horizon_available'),
    neutron_available     => hiera('havana::tempest::neutron_available'),
    nova_available        => hiera('havana::tempest::nova_available'),
    swift_available       => hiera('havana::tempest::swift_available'),
    configure_images      => hiera('havana::tempest::configure_images'),
    image_name            => hiera('havana::tempest::image_name'),
    image_name_alt        => hiera('havana::tempest::image_name_alt'),
    configure_networks    => hiera('havana::tempest::configure_network'),
    public_network_name   => $public_network_name,
    identity_uri          => "http://${api_ip}:5000/v2.0/",
    admin_username        => $admin_user,
    admin_password        => $users[$admin_user]['password'],
    admin_tenant_name     => $users[$admin_user]['tenant'],
    username              => $user,
    password              => $users[$user]['password'],
    tenant_name           => $users[$user]['tenant'],
    alt_username          => $alt_user,
    alt_password          => $users[$alt_user]['password'],
    alt_tenant_name       => $users[$alt_user]['tenant'],
    #require              => Neutron_network[$public_network_name],
  }
}
