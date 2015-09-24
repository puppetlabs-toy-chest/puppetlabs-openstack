define openstack::resources::database (
  $user = getvar("::openstack::config::mysql_user_${title}"),
  $password = getvar("::openstack::config::mysql_pass_${title}"),
) {
  class { "::${title}::db::mysql":
    user          => $user,
    password      => $password,
    dbname        => $title,
    allowed_hosts => $::openstack::config::mysql_allowed_hosts,
    require       => Anchor['database-service'],
  }
}
