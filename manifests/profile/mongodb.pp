# The profile to install an OpenStack specific MongoDB server
class havana::profile::mongodb {
  $management_network = hiera('havana::network::management')
  $inferred_address = ip_for_network($management_network)
  $explicit_address = hiera('havana::controller::address::management')

  if $inferred_address != $explicit_address {
    fail("MongoDB setup failed. The inferred location of the database based on the
    havana::network::management hiera value is ${inferred_address}. The
    explicit address from havana::controller::address::management
    is ${explicit_address}. Please correct this difference.")
  }

  class { '::mongodb::server':
    bind_ip => ['127.0.0.1', hiera('havana::controller::address::management')],
  }

  class { '::mongodb::client': }
}
