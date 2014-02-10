#The profile to set up the Ceilometer API
class havana::profile::ceilometer::api {
  havana::resources::controller { 'ceilometer': }

  havana::resources::firewall { 'Ceilometer API':
    port => '8777',
  }

  class { '::ceilometer::keystone::auth':
    password         => hiera('havana::ceilometer::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('havana::region'),
  }

  class { '::ceilometer::agent::central':
  }

  class { '::ceilometer::expirer':
    time_to_live => '2592000'
  }

  class { '::ceilometer::alarm::notifier':
  }

  class { '::ceilometer::alarm::evaluator':
  }

  class { '::ceilometer::collector': }

  class { '::havana::profile::ceilometer::common':
    is_controller => true,
  }

  mongodb_database { 'ceilometer':
    ensure  => present,
    tries   => 20,
    require => Class['mongodb::server'],
  } 

  mongodb_user { 'ceilometer':
    ensure        => present,
    password_hash => mongodb_password('ceilometer', 'password'),
    database      => ceilometer,
    roles         => ['readWrite', 'dbAdmin'],
    tries         => 10,
    require       => [Class['mongodb::server'], Class['mongodb::client']],
  }

  Class['::mongodb::server'] -> Class['::mongodb::client'] -> Exec['ceilometer-dbsync']
}
