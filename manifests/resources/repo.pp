#
# Sets up the package repos necessary to use OpenStack
# on RHEL-alikes and Ubuntu
#
class openstack::resources::repo(
  $release = 'icehouse'
) {
  case $release {
    'icehouse', 'havana', 'grizzly': {
      if $::osfamily == 'RedHat' {
        class {'openstack::resources::repo::rdo': release => $release }
        class {'openstack::resources::repo::erlang': }
      } elsif $::osfamily == 'Debian' {
        class {'openstack::resources::repo::uca': release => $release }
      }
    }
    default: {
      fail { "FAIL: openstack::resources::repo parameter 'release' of '${release}' not recognized; please use one of 'icehouse', 'havana', 'grizzly'.": }
    }
  }
}
