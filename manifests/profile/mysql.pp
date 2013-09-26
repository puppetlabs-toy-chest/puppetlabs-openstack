# The profile to install an OpenStack specific mysql server
class grizzly::profile::mysql {

  $management_device = hiera('grizzly::network::management::device')
  $inferred_address = getvar("ipaddress_${management_device}")
  $explicit_address = hiera('grizzly::controller::address::management')

  if $inferred_address != $explicit_address {
    fail("MySQL setup failed. The inferred location of the database based on the
    grizzly::network::management::device hiera value is ${inferred_address}. The
    explicit address from grizzly::controller::address::management
    is ${explicit_address}. Please correct this difference.")
  }

  class { 'mysql::server':
    config_hash       => {
      'root_password' => hiera('grizzly::mysql::root_password'),
      'bind_address'  => hiera('grizzly::controller::address::management'),
    },
  }

  class { 'mysql::server::account_security': }
}
