# The profile to set up the Ceilometer API
# For co-located api and worker nodes this appear
# after openstack::profile::ceilometer::agent
class openstack::profile::ceilometer::api {
  openstack::resources::controller { 'ceilometer': }

  openstack::resources::firewall { 'Ceilometer API':
    port => '8777',
  }

  class { '::ceilometer::keystone::auth':
    password         => $::openstack::ceilometer_password,
    public_address   => $::openstack::controller_address_api,
    admin_address    => $::openstack::controller_address_management,
    internal_address => $::openstack::controller_address_management,
    region           => $::openstack::region,
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

  include ::openstack::common::ceilometer

  mongodb_database { 'ceilometer':
    ensure  => present,
    tries   => 20,
    require => Class['mongodb::server'],
  }

  $mongo_username = $::openstack::ceilometer_mongo_username
  $mongo_password = $::openstack::ceilometer_mongo_password

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
