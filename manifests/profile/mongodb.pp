# The profile to install an OpenStack specific MongoDB server
class havana::profile::mongodb {
  $management_device = hiera('havana::network::management::device')
  $inferred_address = getvar("ipaddress_${management_device}")
  $explicit_address = hiera('havana::controller::address::management')

  if $inferred_address != $explicit_address {
    fail("MongoDB setup failed. The inferred location of the database based on the
    havana::network::management::device hiera value is ${inferred_address}. The
    explicit address from havana::controller::address::management
    is ${explicit_address}. Please correct this difference.")
  }

  class { '::mongodb::server':
    auth => true,
  }
}
