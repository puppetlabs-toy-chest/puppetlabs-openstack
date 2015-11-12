# RDO repo (supports both RHEL-alikes and Fedora, requires EPEL)
class openstack::resources::repo::rdo(
  $release = 'liberty'
) {

  class { 'openstack_extras::repo::redhat::redhat':
      release => $release
  }

#  $release_cap = capitalize($release)



#  if $::osfamily == 'RedHat' {
#    case $::operatingsystem {
#      fedora: { $dist = 'fedora' }
#      default: { $dist = 'epel' }
#    }
#    # $lsbmajdistrelease is only available with redhat-lsb installed
#    $osver = regsubst($::operatingsystemrelease, '(\d+)\..*', '\1')
#
#    yumrepo { 'juno-release':
#      baseurl  => "http://repos.fedorapeople.org/repos/openstack/openstack-juno/${dist}-${osver}/",
#      descr    => "OpenStack ${release_cap} Repository",
#      enabled  => 1,
#      gpgcheck => 0,
#      #  gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-RDO-${release_cap}",
#      priority => 98,
#      notify   => Exec['yum_refresh'],
#    }
#
#    yumrepo { 'rdo-release':
#      baseurl  => "http://repos.fedorapeople.org/repos/openstack/openstack-${release}/${dist}-${osver}/",
#      descr    => "OpenStack ${release_cap} Repository",
#      enabled  => 1,
#      gpgcheck => 0,
#      #  gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-RDO-${release_cap}",
#      priority => 97,
#      notify   => Exec['yum_refresh'],
#    }
#
#    yumrepo { 'delorean':
#      baseurl  => 'https://repos.fedorapeople.org/repos/openstack/openstack-trunk/epel-7/rc1-Apr21',
##      descr    => 'Kilo',
#      enabled  => 1,
#      gpgcheck => 0,
#      priority => 96,
#      notify   => Exec['yum_refresh'],
#    }
#
    #    file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-RDO-${release_cap}":
    #  source => "puppet:///modules/openstack/RPM-GPG-KEY-RDO-${release_cap}",
    #  owner  => root,
    #  group  => root,
    #  mode   => '0644',
    #  before => Yumrepo['rdo-release'],
    #}
#    Yumrepo<||> -> Package<||>
#  }
}
