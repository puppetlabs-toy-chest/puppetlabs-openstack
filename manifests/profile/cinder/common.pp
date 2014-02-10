# common configuration for cinder profiles
class havana::profile::cinder::common {
  class { '::cinder':
    sql_connection    => $::havana::resources::connectors::cinder,
    rabbit_host       => hiera('havana::controller::address::management'),
    rabbit_userid     => hiera('havana::rabbitmq::user'),
    rabbit_password   => hiera('havana::rabbitmq::password'),
    debug             => hiera('havana::cinder::debug'),
    verbose           => hiera('havana::cinder::verbose'),
  }
}
