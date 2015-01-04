# Common class for cinder installation
# Private, and should not be used on its own
class openstack::common::cinder {
  class { '::cinder':
    database_connection  => $::openstack::resources::connectors::cinder,
    rabbit_host     => $::openstack::config::controller_address_management,
    rabbit_userid   => $::openstack::config::rabbitmq_user,
    rabbit_password => $::openstack::config::rabbitmq_password,
    debug           => $::openstack::config::debug,
    verbose         => $::openstack::config::verbose,
    mysql_module    => '2.2',
  }

  $storage_server = $::openstack::config::storage_address_api
  $glance_api_server = "${storage_server}:9292"

  class { '::cinder::glance':
    glance_api_servers => [ $glance_api_server ],
  }
}
