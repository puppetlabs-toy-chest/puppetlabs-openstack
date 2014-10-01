class openstack::resources::repo::epel {
  if ($::osfamily == 'RedHat' and
      $::operatingsystem != 'Fedora' and
      $::operatingsystemrelease =~ /^7\..*$/) {
    include openstack::resources::repo::yum_refresh

    yumrepo { 'epel':
      mirrorlist     => 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch',
      descr          => 'Extra Packages for Enterprise Linux 7 - $basearch',
      enabled        => 1,
      gpgcheck       => 1,
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7',
      failovermethod => priority,
      notify         => Exec['yum_refresh']
    }
    file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7':
      source => 'puppet:///modules/openstack/RPM-GPG-KEY-EPEL-7',
      owner  => root,
      group  => root,
      mode   => '0644',
      before => Yumrepo['epel'],
    }
    Yumrepo['epel'] -> Package<||>
  }
}
