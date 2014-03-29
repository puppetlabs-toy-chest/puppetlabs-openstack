#
# Sets up the package repos necessary to use OpenStack
# on RHEL-alikes and Ubuntu
#
class havana::resources::repo(
  $release = 'havana'
) {
  case $release {
    'icehouse', 'havana', 'grizzly': {
      if $::osfamily == 'RedHat' {
        class {'havana::resources::repo::rdo': release => $release }
      } elsif $::operatingsystem == 'Ubuntu' {
        class {'havana::resources::repo::uca': release => $release }
      }
    }
    default: {
      fail { "FAIL: havana::resources::repo parameter 'release' of '${release}' not recognized; please use one of 'icehouse', 'havana', 'grizzly'.": }
    }
  }
}
