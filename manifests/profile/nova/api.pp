# The profile to set up the Nova controller (several services)
class openstack::profile::nova::api {
  openstack::resources::controller { 'nova': }
  openstack::resources::database { 'nova': }
  openstack::resources::firewall { 'Nova API': port => '8774', }
  openstack::resources::firewall { 'Nova Metadata': port => '8775', }
  openstack::resources::firewall { 'Nova EC2': port => '8773', }
  openstack::resources::firewall { 'Nova S3': port => '3333', }
  openstack::resources::firewall { 'Nova novnc': port => '6080', }

  class { "::nova::db::mysql_api":
    user          => 'novaapi',
    password      => $::openstack::config::mysql_service_password,
    dbname        => 'novaapi',
    allowed_hosts => $::openstack::config::mysql_allowed_hosts,
    require       => Anchor['database-service'],
  }

  class { '::nova::keystone::auth':
    password         => $::openstack::config::nova_password,
    public_address   => $::openstack::config::controller_address_api,
    admin_address    => $::openstack::config::controller_address_management,
    internal_address => $::openstack::config::controller_address_management,
    region           => $::openstack::config::region,
  }

  include ::openstack::common::nova
}
