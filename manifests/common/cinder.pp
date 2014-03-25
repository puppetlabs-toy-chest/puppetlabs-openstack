# Common class for cinder installation
# Private, and should not be used on its own
class havana::common::cinder {
  class { '::cinder':
    sql_connection    => $::havana::resources::connectors::cinder,
    rabbit_host       => hiera('havana::controller::address::management'),
    rabbit_userid     => hiera('havana::rabbitmq::user'),
    rabbit_password   => hiera('havana::rabbitmq::password'),
    debug             => hiera('havana::debug'),
    verbose           => hiera('havana::verbose'),
  }
}
