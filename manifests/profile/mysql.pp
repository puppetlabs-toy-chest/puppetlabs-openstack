# The profile to install an OpenStack specific mysql server
class openstack::profile::mysql {

  $management_network = $::openstack::config::network_management

  class { '::mysql::server':
    root_password    => $::openstack::config::mysql_root_password,
    restart          => true,
    override_options => {
      'mysqld' => {
                    'bind_address'           => $::openstack::config::controller_address_management,
                    'default-storage-engine' => 'innodb',
                  }
    }
  }

  class { '::mysql::bindings':
    python_enable => true,
  }

  Service['mysqld'] -> Anchor['database-service']

  class { 'mysql::server::account_security': }
}
