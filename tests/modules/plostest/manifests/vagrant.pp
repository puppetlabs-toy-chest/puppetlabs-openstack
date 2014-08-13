class plostest::vagrant {
  $testhomename = "${::env_pwd}/${::env_scenario}"
  $vagrantfilename = "${testhomename}/Vagrantfile"
  $sitefilename = "${testhomename}/site.pp"
  $puppetfilename = "${testhomename}/Puppetfile"
  $scenario = loadscenario("scenarios/${::env_scenario}")
  $depdata = loadscenario('openstacklibs')
  $vagrant_box  = $::env_vagrantbox

  file { $testhomename:
    ensure => directory,
  } ->
  file { $vagrantfilename:
    ensure  => present,
    content => template('plostest/Vagrantfile.erb'),
  } ->
  file { $sitefilename:
    ensure  => present,
    content => template('plostest/site.erb'),
  } ->
  file { $puppetfilename:
    ensure  => present,
    content => template('plostest/Puppetfile.erb'),
  }
  
}
