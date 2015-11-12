define openstack::resources::database () {
  class { "::${title}::db::mysql":
    user          => $title,
    password      => $::openstack::config::mysql_service_password,
    dbname        => $title,
    allowed_hosts => $::openstack::config::mysql_allowed_hosts,
    require       => Anchor['database-service'],
  }
}
