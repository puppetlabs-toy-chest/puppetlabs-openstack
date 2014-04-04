# Common class for cinder installation
# Private, and should not be used on its own
class openstack::common::cinder {
  class { '::cinder':
    sql_connection    => $::openstack::resources::connectors::cinder,
    rabbit_host       => hiera('openstack::controller::address::management'),
    rabbit_userid     => hiera('openstack::rabbitmq::user'),
    rabbit_password   => hiera('openstack::rabbitmq::password'),
    debug             => hiera('openstack::debug'),
    verbose           => hiera('openstack::verbose'),
  }
}
