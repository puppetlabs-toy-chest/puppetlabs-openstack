class openstack::profile::sahara {
  openstack::resources::firewall { 'Sahara API': port => '8386', }
  #openstack::resources::database { 'sahara': }

  #class { '::sahara': 
  #  sahara_verbose     => $::openstack::config::verbose,
  #  sahara_debug       => $::openstack::config::debug,
  #  sql_connection     => $::openstack::resources::connectors::sahara,
  #  keystone_auth_host => $::openstack::config::controller_address_management,
  #  keystone_password  => $::openstack::config::sahara_password,
  #  region_name        => $::openstack::config::region,
  #  rabbit_host        => $::openstack::config::controller_address_management,
  #  rabbit_user        => $::openstack::config::rabbitmq_user,
  #  rabbit_password    => $::openstack::config::rabbitmq_password,
  #  use_neutron        => 'true',
  #}
  #
  #class { '::sahara::keystone::auth':
  #  password         => $::openstack::config::sahara_password,
  #  public_address   => $::openstack::config::controller_address_api,
  #  admin_address    => $::openstack::config::controller_address_management,
  #  internal_address => $::openstack::config::controller_address_management,
  #  region           => $::openstack::config::region,
  #}
}
