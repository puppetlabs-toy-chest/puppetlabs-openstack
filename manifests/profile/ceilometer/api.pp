# The profile to set up the Ceilometer API
# For co-located api and worker nodes this appear
# after openstack::profile::ceilometer::agent
class openstack::profile::ceilometer::api {

  $mongo_username                = $::openstack::config::ceilometer_mongo_username
  $mongo_password                = $::openstack::config::ceilometer_mongo_password
  $ceilometer_management_address = $::openstack::config::ceilometer_address_management
  $controller_management_address = $::openstack::config::controller_address_management


  if ! $mongo_username or ! $mongo_password {
    $mongo_connection = "mongodb://${ceilometer_management_address}:27017/ceilometer"
  } else {
    $mongo_connection = "mongodb://${mongo_username}:${mongo_password}@${ceilometer_management_address}:27017/ceilometer"
  }

  openstack::resources::firewall { 'Ceilometer API':
    port => '8777',
  }

  include ::openstack::common::ceilometer

  class { '::ceilometer::keystone::auth':
    password         => $::openstack::config::ceilometer_password,
    public_address   => $::openstack::config::controller_address_api,
    admin_address    => $::openstack::config::controller_address_management,
    internal_address => $::openstack::config::controller_address_management,
    region           => $::openstack::config::region,
  }

  class { '::ceilometer::api':
    keystone_host     => $controller_management_address,
    keystone_password => $::openstack::config::ceilometer_password,
  }

  class { '::ceilometer::db':
    database_connection => $mongo_connection,
  }

  class { '::ceilometer::agent::central':
  }

  class { '::ceilometer::expirer':
    time_to_live => '2592000'
  }

  # For the time being no upstart script are provided
  # in Ubuntu 12.04 Cloud Archive. Bug report filed
  # https://bugs.launchpad.net/cloud-archive/+bug/1281722
  # https://bugs.launchpad.net/ubuntu/+source/ceilometer/+bug/1250002/comments/5
  if $::osfamily != 'Debian' {
    class { '::ceilometer::alarm::notifier':
    }

    class { '::ceilometer::alarm::evaluator':
    }
  }

  class { '::ceilometer::collector': }

  mongodb_database { 'ceilometer':
    ensure  => present,
    tries   => 20,
    require => Class['mongodb::server'],
  }

  if $mongo_username and $mongo_password {
    mongodb_user { $mongo_username:
      ensure        => present,
      password_hash => mongodb_password($mongo_username, $mongo_password),
      database      => 'ceilometer',
      roles         => ['readWrite', 'dbAdmin'],
      tries         => 10,
      require       => [Class['mongodb::server'], Class['mongodb::client']],
      before        => Exec['ceilometer-dbsync'],
    }
  }

  Class['::mongodb::server'] -> Class['::mongodb::client'] -> Exec['ceilometer-dbsync']
}
