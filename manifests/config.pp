# private global parameters class. Do not use directly!
class openstack::config (
  $use_hiera = undef,
  $region = undef,
  $network_api = undef,
  $networks = undef,
  $subnets = undef,
  $routers = undef,
  $router_interfaces = undef,
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
  $mysql_user_keystone = undef,
  $mysql_pass_keystone = undef,
  $mysql_user_cinder = undef,
  $mysql_pass_cinder = undef,
  $mysql_user_glance = undef,
  $mysql_pass_glance = undef,
  $mysql_user_nova = undef,
  $mysql_pass_nova = undef,
  $mysql_user_neutron = undef,
  $mysql_pass_neutron = undef,
  $mysql_user_heat = undef,
  $mysql_pass_heat = undef,
  $rabbitmq_hosts = undef,
  $rabbitmq_user = undef,
  $rabbitmq_password = undef,
  $keystone_admin_token = undef,
  $keystone_admin_email = undef,
  $keystone_admin_password = undef,
  $keystone_tenants = undef,
  $keystone_users = undef,
  $keystone_use_httpd = undef,
  $glance_password = undef,
  $glance_api_servers = undef,
  $images = undef,
  $cinder_password = undef,
  $cinder_volume_size = undef,
  $swift_password = undef,
  $swift_hash_suffix = undef,
  $nova_libvirt_type = undef,
  $nova_password = undef,
  $neutron_password = undef,
  $neutron_shared_secret = undef,
  $neutron_core_plugin = 'neutron.plugins.ml2.plugin.Ml2Plugin',
  $neutron_service_plugins = [
  'neutron.services.l3_router.l3_router_plugin.L3RouterPlugin',
  'neutron.services.loadbalancer.plugin.LoadBalancerPlugin',
  'neutron.services.vpn.plugin.VPNDriverPlugin',
  'neutron.services.firewall.fwaas_plugin.FirewallPlugin',
  'neutron.services.metering.metering_plugin.MeteringPlugin'
  ],
  $neutron_tunneling = undef,
  $neutron_tunnel_types = undef,
  $neutron_tenant_network_type = undef,
  $neutron_type_drivers = undef,
  $neutron_mechanism_drivers = undef,
  $neutron_tunnel_id_ranges = undef,
  $plumgrid_director_vip = undef,
  $plumgrid_username = undef,
  $plumgrid_password = undef,
  $ceilometer_address_management = undef,
  $ceilometer_mongo_username = undef,
  $ceilometer_mongo_password = undef,
  $ceilometer_password = undef,
  $ceilometer_meteringsecret = undef,
  $heat_password = undef,
  $heat_encryption_key = undef,
  $horizon_secret_key = undef,
  $horizon_allowed_hosts = undef,
  $horizon_server_aliases = undef,
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
}
