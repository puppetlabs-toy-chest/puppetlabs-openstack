# private global parameters class. Do not use directly!
class openstack::config (
  $use_hiera = undef,
  $rdo_repo = false,
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
  $neutron_tunneling = undef,
  $neutron_tunnel_types = undef,
  $neutron_tenant_network_type = undef,
  $neutron_type_drivers = undef,
  $neutron_mechanism_drivers = undef,
  $neutron_tunnel_id_ranges = undef,
  $enable_plumgrid = undef,
  $pg_controller = false,
  $pg_compute = false,
  $pg_director_server = undef,
  $pg_username = undef,
  $pg_password = undef,
  $pg_enable_metadata_agent = false,
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
}
