class plostest::vagrant {
  $testhomename = "${::env_pwd}/${::env_scenario}"
  $vagrantfilename = "${testhomename}/Vagrantfile"
  $scenario = loadscenario("${::env_scenario}")
  $vagrant_box  = $::env_vagrantbox

  file { $testhomename:
    ensure => directory,
  } ->
  file { $vagrantfilename:
    ensure  => present,
    content => template('plostest/Vagrantfile.erb'),
  }
}
