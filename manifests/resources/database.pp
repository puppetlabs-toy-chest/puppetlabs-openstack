define havana::resources::database () {
  class { "::${title}::db::mysql":
    user          => $title,
    password      => hiera("havana::mysql::service_password"),
    dbname        => $title,
    allowed_hosts => hiera('havana::mysql::allowed_hosts'),
  }
}
