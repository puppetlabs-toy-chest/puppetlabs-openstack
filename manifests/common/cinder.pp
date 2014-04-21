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

  $storage_server = hiera('openstack::storage::address::api')
  $glance_api_server = "${storage_server}:9292"

  class { '::cinder::glance':
    glance_api_servers => [ $glance_api_server ],
  }
}
