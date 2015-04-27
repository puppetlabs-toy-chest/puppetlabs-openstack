# The profile to set up the Nova controller (several services)
class openstack::profile::nova::api {

  $controller_management_address = $::openstack::config::controller_address_management

  openstack::resources::database { 'nova': }
  openstack::resources::firewall { 'Nova API': port => '8774', }
  openstack::resources::firewall { 'Nova Metadata': port => '8775', }
  openstack::resources::firewall { 'Nova EC2': port => '8773', }
  openstack::resources::firewall { 'Nova S3': port => '3333', }
  openstack::resources::firewall { 'Nova novnc': port => '6080', }

  class { '::nova::keystone::auth':
    password         => $::openstack::config::nova_password,
    public_address   => $::openstack::config::controller_address_api,
    admin_address    => $::openstack::config::controller_address_management,
    internal_address => $::openstack::config::controller_address_management,
    region           => $::openstack::config::region,
  }

  include ::openstack::common::nova

  class { '::nova::api':
    admin_password                       => $::openstack::config::nova_password,
    auth_host                            => $controller_management_address,
    neutron_metadata_proxy_shared_secret => $::openstack::config::neutron_shared_secret,
    enabled                              => true,
  }

  class { '::nova::compute::neutron': }

  class { '::nova::vncproxy':
    host    => $::openstack::controller_address_api,
    enabled => true,
  }

  class { [
    'nova::scheduler',
    'nova::objectstore',
    'nova::cert',
    'nova::consoleauth',
    'nova::conductor'
  ]:
    enabled => true
  }
}
