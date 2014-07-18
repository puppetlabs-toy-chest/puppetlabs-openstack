define openstack::resources::database () {
  class { "::${title}::db::mysql":
    user          => $title,
    password      => $::openstack::config::mysql_service_password,
    dbname        => $title,
    allowed_hosts => $::openstack::config::mysql_allowed_hosts,
    mysql_module  => '2.2',
    require       => Anchor['database-service'],
  }
}
