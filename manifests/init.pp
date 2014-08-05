# = Puppet Labs OpenStack Parameters
# == Class: openstack
#
# === Authors
#
# Christian Hoge <chris.hoge@puppetlabs.com>
#
# === Copyright
#
# Copyright 2013-2014 Puppet Labs.
#
# Class for configuring the global installation parameters for the puppetlabs-openstack module.
# By default, the module will try to find the parameters in hiera. If the hiera lookup fails,
# it will fall back to the parameters passed to this class. The use of this class is optional,
# and will be automatically included through the configuration. If the ::openstack
# class is used, it needs appear first in node parse order to ensure proper variable
# initialization.
#
# [*region*]
#   The region name to set up the OpenStack services.
#
# == Networks
# [*network_api*]
#   The CIDR of the api network. This is the network that all public
#   api calls are made on, as well as the network to access Horizon.
#
# [*network_external*]
#   The CIDR of the external network. May be the same as network_api.
#   This is the network that floating IP addresses are allocated in
#   to allow external access to virtual machine instances.
#
# [*network_management*]
#   The CIDR of the management network.
#
# [*network_data*]
#   The CIDR of the data network. May be the same as network_management.
#
# [*network_external_ippool_start*]
#   The starting address of the external network IP pool. Must be contained
#   within the network_external CIDR range.
#
# [*network_external_ippool_end*]
#   The end address of the external network IP pool. Must be contained within
#   the network_external CIDR range, and greater than network_external_ippool_start.
#
# [*network_external_gateway*]
#   The gateway address for the external network.
#
# [*network_external_dns*]
#   The DNS server for the external network.
#
# == Private Neutron Network
# [*network_neutron_private*]
#   The CIDR of the automatically created private network.
#
# == Fixed IPs (controllers)
# [*controller_address_api*]
#   The API IP address of the controller node. Must be in the network_api CIDR.
#
# [*controller_address_management*]
#   The management IP address of the controller node. Must be in the network_management CIDR.
#
# [*storage_address_api*]
#   The API IP address of the storage node. Must be in the network_api CIDR.
#
# [*storage_address_management*]
#   The management IP address of the storage node. Must be in the network_management CIDR.
#
# == Database
# [*mysql_root_password*]
#   The root password for the MySQL database.
#
# [*mysql_service_password*]
#   The MySQL shared password for all of the OpenStack services.
#
# [*mysql_allowed_hosts*]
#   Array of hosts that are allowed to access the MySQL database. Should include all of the network_management CIDR.
#   Example configuration: ['localhost', '127.0.0.1', '172.16.33.%']
#
# == RabbitMQ
# [*rabbitmq_user*]
#   The username for the RabbitMQ queues.
#
# [*rabbitmq_password*]
#   The password for accessing the RabbitMQ queues.
#
# == Keystone
# [*keystone_admin_token*]
#   The global administrative token for the Keystone service.
#
# [*keystone_admin_email*]
#   The e-mail address of the Keystone administrator.
#
# [*keystone_admin_password*]
#   The password for keystone user in Keystone.
#
# [*keystone_tenants*]
#   The intial keystone tenants to create. Should be a Hash in the form of: 
#   {'tenant_name1' => { 'descritpion' => 'Tenant Description 1'}, 
#    'tenant_name2' => {'description' => 'Tenant Description 2'}}
#
# [*keystone_users*]
#   The intial keystone users to create. Should be a Hash in the form of:
#   {'user1' => {'password' => 'somepass1', 'tenant' => 'some_preexisting_tenant',
#                'email' => 'foo@example.com', 'admin'  =>  'true'},
#   'user2' => {'password' => 'somepass2', 'tenant' => 'some_preexisting_tenant',
#                'email' => 'foo2@example.com', 'admin'  =>  'false'}} 
#
# == Glance
# [*glance_password*]
#   The password for the glance user in Keystone.
#
# ==Cinder
# [*cinder_password*]
#   The password for the cinder user in Keystone.
#
# [*cinder_volume_size*]
#   The size of the Cinder loopback storage device. Example: '8G'.
#
# == Swift
# [*swift_password*]
#    The password for the swift user in Keystone.
#
# [*swift_hash_suffix*]
#   The hash suffix for Swift ring communication.
#
# == Nova
# [*nova_libvirt_type*]
#   The type of hypervisor to use for Nova. Typically 'kvm' for
#   hardware accelerated virtualization or 'qemu' for software virtualization.
#
# [*nova_password*]
#   The password for the nova user in Keystone.
#
# == Neutron
# [*neutron_password*]
#   The password for the neutron user in Keystone.
#
# [*neutron_shared_secret*]
#   The shared secret to allow for communication between Neutron and Nova.
#
# [*neutron_tunneling*] (Deprecated)
#   Boolean. Whether to enable Neutron tunneling.
#   Default to true.
#
# [*neutron_tunnel_types*] (Deprecated)
#   Array. Tunnel types to use
#   Defaults to ['gre'],
#
# [*neutron_tenant_network_type*] (Deprecated)
#   Array. Tenant network type.
#   Defaults to ['gre'],
#
# [*neutron_type_drivers*] (Deprecated)
#   Array. Neutron type drivers to use.
#   Defaults to ['gre'],
#
# [*neutron_mechanism_drivers*] (Deprecated)
#   Defaults to ['openvswitch'].
#
# [*neutron_tunnel_id_ranges*] (Deprecated)
#   Neutron tunnel id ranges.
#   Defaults to ['1:1000']
#
# == Ceilometer
# [*ceilometer_mongo_password*]
#   The password for the MongoDB Ceilometer user.
#
# [*ceilometer_password*]
#   The password for the ceilometer user in Keystone.
#
# [*ceilometer_meteringsecret*]
#   The shared secret to allow communication betweek Ceilometer and other
#   OpenStack services.
#
# == Heat
# [*heat_password*]
#   The password for the heat user in Keystone.
#
# [*heat_encryption_key*]
#   The encyption key for the shared heat services.
#
# == Horizon
# [*horizon_secret_key*]
#   The secret key for the Horizon service.
#
# == Log levels
# [*verbose*]
#   Boolean. Determines if verbose is enabled for all OpenStack services.
#
# [*debug*]
#   Boolean. Determines if debug is enabled for all OpenStack services.
#
# == Tempest
# [*tempest_configure_images*]
#   Boolean. Whether Tempest should configure images.
#
# [*tempest_image_name*]
#   The name of the primary image to use for tests.
#
# [*tempest_image_name_alt*]
#   The name of the secondary image to use for tests. If the same as the
#   tempest_image_primary, some tests will be disabled.
#
# [*tempest_username*]
#   The login username to run tempest tests.
#
# [*tempest_username_alt*]
#   The alternate login username for tempest tests.
#
# [*tempest_username_admin*]
#   The uername for the Tempest admin user.
#
# [*tempest_configure_network*]
#   Boolean. If Tempest should configure test networks.
#
# [*tempest_public_network_name*]
#   The name of the public neutron network for Tempest to connect to.
#
# [*tempest_cinder_available*]
#   Boolean. If Cinder services are available.
#
# [*tempest_glance_available*]
#   Boolean. If Glance services are available.
#
# [*tempest_horizon_available*]
#   Boolean. If Horizon is available.
#
# [*tempest_nova_available*]
#   Boolean. If Nova services are available.
#
# [*tempest_neutron_available*]
#   Boolean. If Neutron services are availale.
#
# [*tempest_heat_available*]
#   Boolean. If Heat services are available.
#
# [*tempest_swift_available*]
#   Boolean. If Swift services are available.
#
class openstack (
  $use_hiera = true,
  $region = undef,
  $network_api = undef,
  $network_external = undef,
  $network_management = undef,
  $network_data = undef,
  $network_external_ippool_start = undef,
  $network_external_ippool_end = undef,
  $network_external_gateway = undef,
  $network_external_dns = undef,
  $network_neutron_private = undef,
  $controller_address_api = undef,
  $controller_address_management = undef,
  $storage_address_api = undef,
  $storage_address_management = undef,
  $mysql_root_password = undef,
  $mysql_service_password = undef,
  $mysql_allowed_hosts = undef,
  $rabbitmq_user = undef,
  $rabbitmq_password = undef,
  $keystone_admin_token = undef,
  $keystone_admin_email = undef,
  $keystone_admin_password = undef,
  $keystone_tenants = undef,
  $keystone_users = undef,
  $glance_password = undef,
  $cinder_password = undef,
  $cinder_volume_size = undef,
  $swift_password = undef,
  $swift_hash_suffix = undef,
  $nova_libvirt_type = undef,
  $nova_password = undef,
  $neutron_password = undef,
  $neutron_shared_secret = undef,
  $neutron_tunneling = true,
  $neutron_tunnel_types = ['gre'],
  $neutron_tenant_network_type = ['gre'],
  $neutron_type_drivers = ['gre'],
  $neutron_mechanism_drivers = ['openvswitch'],
  $neutron_tunnel_id_ranges = ['1:1000'],
  $ceilometer_mongo_password = undef,
  $ceilometer_password = undef,
  $ceilometer_meteringsecret = undef,
  $heat_password = undef,
  $heat_encryption_key = undef,
  $horizon_secret_key = undef,
  $tempest_configure_images    = undef,
  $tempest_image_name          = undef,
  $tempest_image_name_alt      = undef,
  $tempest_username            = undef,
  $tempest_username_alt        = undef,
  $tempest_username_admin      = undef,
  $tempest_configure_network   = undef,
  $tempest_public_network_name = undef,
  $tempest_cinder_available    = undef,
  $tempest_glance_available    = undef,
  $tempest_horizon_available   = undef,
  $tempest_nova_available      = undef,
  $tempest_neutron_available   = undef,
  $tempest_heat_available      = undef,
  $tempest_swift_available     = undef,
  $verbose = undef,
  $debug = undef,
) {
  if $use_hiera {
    class { '::openstack::config':
      region                        => hiera(openstack::region),
      network_api                   => hiera(openstack::network::api),
      network_external              => hiera(openstack::network::external),
      network_management            => hiera(openstack::network::management),
      network_data                  => hiera(openstack::network::data),
      network_external_ippool_start => hiera(openstack::network::external::ippool::start),
      network_external_ippool_end   => hiera(openstack::network::external::ippool::end),
      network_external_gateway      => hiera(openstack::network::external::gateway),
      network_external_dns          => hiera(openstack::network::external::dns),
      network_neutron_private       => hiera(openstack::network::neutron::private),
      controller_address_api        => hiera(openstack::controller::address::api),
      controller_address_management => hiera(openstack::controller::address::management),
      storage_address_api           => hiera(openstack::storage::address::api),
      storage_address_management    => hiera(openstack::storage::address::management),
      mysql_root_password           => hiera(openstack::mysql::root_password),
      mysql_service_password        => hiera(openstack::mysql::service_password),
      mysql_allowed_hosts           => hiera(openstack::mysql::allowed_hosts),
      rabbitmq_user                 => hiera(openstack::rabbitmq::user),
      rabbitmq_password             => hiera(openstack::rabbitmq::password),
      keystone_admin_token          => hiera(openstack::keystone::admin_token),
      keystone_admin_email          => hiera(openstack::keystone::admin_email),
      keystone_admin_password       => hiera(openstack::keystone::admin_password),
      keystone_tenants              => hiera(openstack::keystone::tenants),
      keystone_users                => hiera(openstack::keystone::users),
      glance_password               => hiera(openstack::glance::password),
      cinder_password               => hiera(openstack::cinder::password),
      cinder_volume_size            => hiera(openstack::cinder::volume_size),
      swift_password                => hiera(openstack::swift::password),
      swift_hash_suffix             => hiera(openstack::swift::hash_suffix),
      nova_libvirt_type             => hiera(openstack::nova::libvirt_type),
      nova_password                 => hiera(openstack::nova::password),
      neutron_password              => hiera(openstack::neutron::password),
      neutron_shared_secret         => hiera(openstack::neutron::shared_secret),
      neutron_tunneling             => hiera(openstack::neutron::neutron_tunneling, $neutron_tunneling),
      neutron_tunnel_types          => hiera(openstack::neutron::neutron_tunnel_type, $neutron_tunnel_types),
      neutron_tenant_network_type   => hiera(openstack::neutron::neutron_tenant_network_type, $neutron_tenant_network_type),
      neutron_type_drivers          => hiera(openstack::neutron::neutron_type_drivers, $neutron_type_drivers),
      neutron_mechanism_drivers     => hiera(openstack::neutron::neutron_mechanism_drivers, $neutron_mechanism_drivers),
      neutron_tunnel_id_ranges      => hiera(openstack::neutron::neutron_tunnel_id_ranges, $neutron_tunnel_id_ranges),
      ceilometer_mongo_password     => hiera(openstack::ceilometer::mongo::password),
      ceilometer_password           => hiera(openstack::ceilometer::password),
      ceilometer_meteringsecret     => hiera(openstack::ceilometer::meteringsecret),
      heat_password                 => hiera(openstack::heat::password),
      heat_encryption_key           => hiera(openstack::heat::encryption_key),
      horizon_secret_key            => hiera(openstack::horizon::secret_key),
      verbose                       => hiera(openstack::verbose),
      debug                         => hiera(openstack::debug),
      tempest_configure_images      => hiera(openstack::tempest::configure_images),
      tempest_image_name            => hiera(openstack::tempest::image_name),
      tempest_image_name_alt        => hiera(openstack::tempest::image_name_alt),
      tempest_username              => hiera(openstack::tempest::username),
      tempest_username_alt          => hiera(openstack::tempest::username_alt),
      tempest_username_admin        => hiera(openstack::tempest::username_admin),
      tempest_configure_network     => hiera(openstack::tempest::configure_network),
      tempest_public_network_name   => hiera(openstack::tempest::public_network_name),
      tempest_cinder_available      => hiera(openstack::tempest::cinder_available),
      tempest_glance_available      => hiera(openstack::tempest::glance_available),
      tempest_horizon_available     => hiera(openstack::tempest::horizon_available),
      tempest_nova_available        => hiera(openstack::tempest::nova_available),
      tempest_neutron_available     => hiera(openstack::tempest::neutron_available),
      tempest_heat_available        => hiera(openstack::tempest::heat_available),
      tempest_swift_available       => hiera(openstack::tempest::swift_available),
    }
  } else {
    class { '::openstack::config':
      region                        => $region,
      network_api                   => $network_api,
      network_external              => $network_external,
      network_management            => $network_management,
      network_data                  => $network_data,
      network_external_ippool_start => $network_external_ippool_start,
      network_external_ippool_end   => $network_external_ippool_end,
      network_external_gateway      => $network_external_gateway,
      network_external_dns          => $network_external_dns,
      network_neutron_private       => $network_neutron_private,
      controller_address_api        => $controller_address_api,
      controller_address_management => $controller_address_management,
      storage_address_api           => $storage_address_api,
      storage_address_management    => $storage_address_management,
      mysql_root_password           => $mysql_root_password,
      mysql_service_password        => $mysql_service_password,
      mysql_allowed_hosts           => $mysql_allowed_hosts,
      rabbitmq_user                 => $rabbitmq_user,
      rabbitmq_password             => $rabbitmq_password,
      keystone_admin_token          => $keystone_admin_token,
      keystone_admin_email          => $keystone_admin_email,
      keystone_admin_password       => $keystone_admin_password,
      keystone_tenants              => $keystone_tenants,
      keystone_users                => $keystone_users,
      glance_password               => $glance_password,
      cinder_password               => $cinder_password,
      cinder_volume_size            => $cinder_volume_size,
      swift_password                => $swift_password,
      swift_hash_suffix             => $swift_hash_suffix,
      nova_libvirt_type             => $nova_libvirt_type,
      nova_password                 => $nova_password,
      neutron_password              => $neutron_password,
      neutron_shared_secret         => $neutron_shared_secret,
      neutron_tunneling             => $neutron_tunneling,
      neutron_tunnel_types          => $neutron_tunnel_types,
      neutron_tenant_network_type   => $neutron_tenant_network_type,
      neutron_type_drivers          => $neutron_type_drivers,
      neutron_mechanism_drivers     => $neutron_mechanism_drivers,
      neutron_tunnel_id_ranges      => $neutron_tunnel_id_ranges,
      ceilometer_mongo_password     => $ceilometer_mongo_password,
      ceilometer_password           => $ceilometer_password,
      ceilometer_meteringsecret     => $ceilometer_meteringsecret,
      heat_password                 => $heat_password,
      heat_encryption_key           => $heat_encryption_key,
      horizon_secret_key            => $horizon_secret_key,
      verbose                       => $verbose,
      debug                         => $debug,
      tempest_configure_images      => $tempest_configure_images,
      tempest_image_name            => $tempest_image_name,
      tempest_image_name_alt        => $tempest_image_name_alt,
      tempest_username              => $tempest_username,
      tempest_username_alt          => $tempest_username_alt,
      tempest_username_admin        => $tempest_username_admin,
      tempest_configure_network     => $tempest_configure_network,
      tempest_public_network_name   => $tempest_public_network_name,
      tempest_cinder_available      => $tempest_cinder_available,
      tempest_glance_available      => $tempest_glance_available,
      tempest_horizon_available     => $tempest_horizon_available,
      tempest_nova_available        => $tempest_nova_available,
      tempest_neutron_available     => $tempest_neutron_available,
      tempest_heat_available        => $tempest_heat_available,
      tempest_swift_available       => $tempest_swift_available,
    }
  }
}
