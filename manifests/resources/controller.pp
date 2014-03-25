# A basic defined resource that only checks for controller
# configuration consistency with the Hiera data
define havana::resources::controller () {
  $api_address = hiera('havana::controller::address::api')
  $management_address = hiera('havana::controller::address::management')

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
