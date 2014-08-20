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
  } 

  $tests = {
    'Vagrantfile'            => { templatename => 'Vagrantfile.erb', },
    'site.pp'                => { templatename => 'site.erb', },
    'Puppetfile'             => { templatename => 'Puppetfile.erb', },
    '10_download_modules.sh' => { templatename => '10_download_modules.sh.erb', },
    '20_up.sh'               => { templatename => '20_up.sh.erb', },
    '30_setup_master.sh'     => { templatename => '30_setup_master.sh.erb', },
    '40_setup_openstack.sh'  => { templatename => '40_setup_openstack.sh.erb', },
    '50_setup_nodes.sh'      => { templatename => '50_setup_nodes.sh.erb', },
    '60_deploy_control.sh'   => { templatename => '60_deploy_control.sh.erb', },
    '70_deploy_nodes.sh'     => { templatename => '70_deploy_nodes.sh.erb', },
    '80_destroy_nodes.sh'    => { templatename => '80_destroy_nodes.sh.erb', },
  }

  create_resources( '::plostest::testtemplate', $tests, { filehome => $testhomename} ) 
}
