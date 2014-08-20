define plostest::testtemplate ($filehome, $templatename)
{
  file { "${filehome}/${name}":
    ensure  => present,
    content => template("plostest/$templatename"),
    require => File[$filehome],
  }
}
