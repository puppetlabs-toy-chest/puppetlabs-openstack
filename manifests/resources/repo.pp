#
# Sets up the package repos necessary to use OpenStack
# on RHEL-alikes and Ubuntu
#
class openstack::resources::repo(
  $release = 'juno',
  $manage_repos = true,
) {
  case $release {
    'juno', 'icehouse', 'havana', 'grizzly': {
      if $::osfamily == 'RedHat' {
        if $manage_repos == true {
          class {'openstack::resources::repo::rdo': release => $release }
          class {'openstack::resources::repo::erlang': }
          class {'openstack::resources::repo::yum_refresh': }
        } else{
          class {'openstack::resources::repo::yum_refresh': }
        }
      } elsif $::osfamily == 'Debian' {
        if $manage_repos == true {
          class {'openstack::resources::repo::uca': release => $release }
        }
      }
    }
    default: {
      fail { "FAIL: openstack::resources::repo parameter 'release' of '${release}' not recognized; please use one of 'juno', 'icehouse', 'havana', 'grizzly'.": }
    }
  }
}
