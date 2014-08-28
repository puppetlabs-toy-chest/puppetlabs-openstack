class plostest::vagrant {
  $testhome = "${::env_ostarget}_${::env_scenario}"
  $testhomename = "${::env_pwd}/${testhome}"
  $vagrantfilename = "${testhomename}/Vagrantfile"
  $sitefilename = "${testhomename}/site.pp"
  $puppetfilename = "${testhomename}/Puppetfile"
  $scenario = loadscenario("scenarios/${::env_scenario}")
  $depdata = loadscenario('openstacklibs')
  $vagrant_box  = $::env_vagrantbox
  $ostarget = $::env_ostarget

  file { $testhomename:
    ensure => directory,
  } 

  $tests = {
    'Vagrantfile'            => { templatename => 'Vagrantfile.erb', },
    'site.pp'                => { templatename => 'site.erb', },
    'Puppetfile'             => { templatename => 'Puppetfile.erb', },
    '10_download_modules.sh' => { templatename => '10_download_modules.sh.erb', filemode => '0744',},
    '20_up.sh'               => { templatename => '20_up.sh.erb', filemode               => '0744',},
    '30_setup_master.sh'     => { templatename => '30_setup_master.sh.erb', filemode     => '0744',},
    '40_setup_openstack.sh'  => { templatename => '40_setup_openstack.sh.erb', filemode  => '0744',},
    '50_setup_nodes.sh'      => { templatename => '50_setup_nodes.sh.erb', filemode      => '0744',},
    '60_deploy_control.sh'   => { templatename => '60_deploy_control.sh.erb', filemode   => '0744',},
    '70_deploy_nodes.sh'     => { templatename => '70_deploy_nodes.sh.erb', filemode     => '0744',},
    '80_destroy_nodes.sh'    => { templatename => '80_destroy_nodes.sh.erb', filemode    => '0744',},
    'openstack.yaml'         => { templatename => 'openstack.yaml.erb' },
    'hiera.yaml'             => { templatename => 'hiera.yaml.erb' },
  }

  create_resources( '::plostest::testtemplate', $tests, { filehome => $testhomename} ) 
}
