define openstack::resources::database (
  $user = getvar("::openstack::mysql_user_${title}"),
  $password = getvar("::openstack::mysql_pass_${title}"),
) {
  class { "::${title}::db::mysql":
    user          => $user,
    password      => $password,
    dbname        => $title,
    allowed_hosts => $::openstack::mysql_allowed_hosts,
    mysql_module  => '2.2',
    require       => Anchor['database-service'],
  }
}
