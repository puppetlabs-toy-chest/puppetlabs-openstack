# The base profile for OpenStack. Installs the repository and ntp
class havana::profile::base {
  # everyone also needs to be on the same clock
  class { '::ntp': }

  # all nodes need the OpenStack repository
  class { '::havana::resources::repo': }

  # database connectors
  class { '::havana::resources::connectors': }

  $management_network = hiera('havana::network::management')
  $management_address = ip_for_network($management_network)
  $controller_management_address = hiera('havana::controller::address::management')

  $management_matches = ($management_address == $controller_management_address)

  $api_network = hiera('havana::network::api')
  $api_address = ip_for_network($api_network)
  $controller_api_address = hiera('havana::controller::address::api')

  $api_matches = ($api_address == $controller_api_address)

  $is_controller = ($management_matches and $api_matches)

  if $is_controller {
    notice("This node is a controller node. ${management_address} == ${controller_management_address} and ${api_address} == ${controller_api_address}")
  } else {
    notice("This node is not a controller node. ${management_address} != ${controller_management_address} or ${api_address} != ${controller_api_address}")
  }
}
