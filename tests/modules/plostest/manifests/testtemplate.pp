define plostest::testtemplate ($filehome, $templatename, $filemode = '0644')
{
  file { "${filehome}/${name}":
    ensure  => present,
    content => template("plostest/$templatename"),
    require => File[$filehome],
    mode    => $filemode,
  }
}
