class openstack::resources::repo::mysql {
  if ($::osfamily == 'RedHat' and
      $::operatingsystem != 'Fedora' and
      $::operatingsystemrelease =~ /^7\..*$/) {
    include openstack::resources::repo::yum_refresh

    yumrepo { 'mysql-56-community':
      baseurl        => 'http://repo.mysql.com/yum/mysql-5.6-community/el/7/$basearch/',
      descr          => 'MySQL 5.6 Community Server',
      enabled        => 1,
      gpgcheck       => 1,
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql',
      failovermethod => priority,
      notify         => Exec['yum_refresh']
    }
    file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql':
      source => 'puppet:///modules/openstack/RPM-GPG-KEY-mysql',
      owner  => root,
      group  => root,
      mode   => '0644',
      before => Yumrepo['mysql-56-community'],
    }
    Yumrepo['mysql-56-community'] -> Package<||>
  }
}
