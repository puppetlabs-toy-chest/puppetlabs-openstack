define havana::resources::database () {
  class { "::${title}::db::mysql":
    user          => $title,
    password      => hiera("openstack::mysql::service_password"),
    dbname        => $title,
    allowed_hosts => hiera('openstack::mysql::allowed_hosts'),
  }
}
