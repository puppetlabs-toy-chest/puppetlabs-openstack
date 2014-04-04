#
# Sets up the package repos necessary to use OpenStack
# on RHEL-alikes and Ubuntu
#
class openstack::resources::repo(
  $release = 'havana'
) {
  case $release {
    'icehouse', 'havana', 'grizzly': {
      if $::osfamily == 'RedHat' {
        class {'openstack::resources::repo::rdo': release => $release }
      } elsif $::operatingsystem == 'Ubuntu' {
        class {'openstack::resources::repo::uca': release => $release }
      }
    }
    default: {
      fail { "FAIL: openstack::resources::repo parameter 'release' of '${release}' not recognized; please use one of 'icehouse', 'havana', 'grizzly'.": }
    }
  }
}
