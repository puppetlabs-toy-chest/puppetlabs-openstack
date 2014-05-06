# The profile to install an OpenStack specific mysql server
class openstack::profile::mysql {

  $management_network = hiera('openstack::network::management')
  $inferred_address = ip_for_network($management_network)
  $explicit_address = hiera('openstack::controller::address::management')

  if $inferred_address != $explicit_address {
    fail("MySQL setup failed. The inferred location of the database based on the
    openstack::network::management hiera value is ${inferred_address}. The
    explicit address from openstack::controller::address::management
    is ${explicit_address}. Please correct this difference.")
  }

  class { '::mysql::server':
    root_password                => hiera('openstack::mysql::root_password'),
    restart                      => true,
    override_options             => {
      'mysqld'                   => {
        'bind_address'           => hiera('openstack::controller::address::management'),
        'default-storage-engine' => 'innodb',
      }
    }
  }

  class { '::mysql::bindings':
    python_enable => true,
    ruby_enable   => true,
  }

  Service['mysqld'] -> Anchor['database-service']

  class { 'mysql::server::account_security': }
}
