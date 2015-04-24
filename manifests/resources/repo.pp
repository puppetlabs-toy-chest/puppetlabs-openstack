class openstack::resources::repo(
  $release = 'juno',
){
  if $::osfamily == 'Debian' {
    if $::operatingsystem == 'Ubuntu' {
      class { '::openstack_extras::repo::debian::ubuntu':
        release         => $release,
        package_require => true,
      }
    } elsif $::operatingsystem == 'Debian' {
      class { '::openstack_extras::repo::debian::debian':
        release         => $release,
        package_require => true,
      }
    } else {
      fail("Operating system ${::operatingsystem} is not supported.")
    }
  } elsif $::osfamily == 'RedHat' {
      class { '::openstack_extras::repo::redhat::redhat':
        release => $release
      }
  } else {
      fail("Operating system family ${::osfamily} is not supported.")
  }
}
