# A basic defined resource that only checks for controller
# configuration consistency with the Hiera data
define havana::resources::controller () {
  $api_device = hiera('havana::network::api::device')
  $api_address = getvar("ipaddress_${api_device}")

  $management_device = hiera('havana::network::management::device')
  $management_address = getvar("ipaddress_${management_device}")

  $explicit_management_address =
    hiera('havana::controller::address::management')
  $explicit_api_address = hiera('havana::controller::address::api')

  if $management_address != $explicit_management_address {
    fail("${title} setup failed. The inferred location of ${title}
    from the havana::network::management::device hiera value is
    ${management_address}. The explicit address
    from havana::controller::address is ${explicit_management_address}.
    Please correct this difference.")
  }

  if $api_address != $explicit_api_address {
    fail("${title} setup failed. The inferred location of ${title}
    from the havana::network::api::device hiera value is
    ${api_address}. The explicit address
    from havana::controller::address::api is ${explicit_api_address}.
    Please correct this difference.")
  }
}
