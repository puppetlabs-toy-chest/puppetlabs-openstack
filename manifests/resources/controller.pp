# A basic defined resource that only checks for controller
# configuration consistency with the Hiera data
define openstack::resources::controller () {
  $api_address = $::openstack::config::controller_address_api
  $management_address = $::openstack::config::controller_address_management

  unless has_ip_address($api_address) {
    fail("${title} setup failed. This node is listed
    as a controller, but does not have the api ip address
    ${api_address}.")
  }

  unless has_ip_address($management_address) {
    fail("${title} setup failed. This node is listed
    as a controller, but does not have the management ip address
    ${management_address}.")
  }
}
