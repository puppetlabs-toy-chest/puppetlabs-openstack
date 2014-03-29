# The profile to install an OpenStack specific mysql server
class havana::profile::auth_file {
  class { '::havana::resources::auth_file':
    admin_tenant    => 'admin',
    admin_password  => hiera('havana::keystone::admin_password'),
    region_name     => hiera('havana::region'),
    controller_node => hiera('havana::controller::address::api'),
  }
}
