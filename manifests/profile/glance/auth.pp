# The profile to set up the endpoints, auth, and database for Glance
class grizzly::profile::glance::auth {
  $explicit_management_address = hiera('grizzly::storage::address::management')
  $explicit_api_address = hiera('grizzly::storage::address::api')

  $controller_address = hiera('grizzly::controller::address::management')

  $sql_password = hiera('grizzly::glance::sql::password')
  $sql_connection =
    "mysql://glance:${sql_password}@${controller_address}/glance"

  class { '::glance::db::mysql':
    user          => 'glance',
    password      => $sql_password,
    dbname        => 'glance',
    allowed_hosts => hiera('grizzly::mysql::allowed_hosts'),
  }

  class  { '::glance::keystone::auth':
    password         => hiera('grizzly::glance::password'),
    public_address   => $explicit_api_address,
    admin_address    => $explicit_management_address,
    internal_address => $explicit_management_address,
    region           => hiera('grizzly::region'),
  }
}
