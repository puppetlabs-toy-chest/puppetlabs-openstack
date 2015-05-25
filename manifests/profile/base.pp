# The base profile for OpenStack. Installs the repository and ntp
class openstack::profile::base {
  # make sure the parameters are initialized
  include ::openstack

  # everyone also needs to be on the same clock
  include ::ntp

  # all nodes need the OpenStack repository
  class { '::openstack::resources::repo': }

  # database anchor
  anchor { 'database-service': }

  $management_network = $::openstack::config::network_management
  $management_address = ip_for_network($management_network)
  $controller_management_address = $::openstack::config::controller_address_management
  $storage_management_address = $::openstack::config::storage_address_management

  $management_matches = ($management_address == $controller_management_address)
  $storage_management_matches = ($management_address == $storage_management_address)

  $api_network = $::openstack::config::network_api
  $api_address = ip_for_network($api_network)
  $controller_api_address = $::openstack::config::controller_address_api
  $storage_api_address    = $::openstack::config::storage_address_api

  $api_matches = ($api_address == $controller_api_address)
  $storage_api_matches = ($api_address == $storage_api_address)

  $is_controller = ($management_matches and $api_matches)
  $is_storage    = ($storage_management_matches and $storage_api_matches)
}
