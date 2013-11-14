# The profile to install an OpenStack specific mysql server
class havana::profile::mysql {

  $management_device = hiera('havana::network::management::device')
  $inferred_address = getvar("ipaddress_${management_device}")
  $explicit_address = hiera('havana::controller::address::management')

  if $inferred_address != $explicit_address {
    fail("MySQL setup failed. The inferred location of the database based on the
    havana::network::management::device hiera value is ${inferred_address}. The
    explicit address from havana::controller::address::management
    is ${explicit_address}. Please correct this difference.")
  }

  class { 'mysql::server':
    config_hash       => {
      'root_password' => hiera('havana::mysql::root_password'),
      'bind_address'  => hiera('havana::controller::address::management'),
    },
  }

  class { 'mysql::server::account_security': }
}
