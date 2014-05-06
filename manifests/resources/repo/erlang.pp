class openstack::resources::repo::erlang {
  if $::osfamily == 'RedHat' {
    case $::operatingsystem {
      centos, redhat, scientific, slc: { $dist = 'centos' }
      fedora: { $dist = 'fedora' }
    }

    $osver = regsubst($::operatingsystemrelease, '(\d+)\..*', '\1')

    # http://packages.erlang-solutions.com/rpm/centos/6/x86_64/

    yumrepo { 'erlang-solutions':
      name     => 'erlang-solutions',
      descr    => 'Erlang Solutions Repository',
      baseurl  => "http://binaries.erlang-solutions.com/rpm/${dist}/${osver}/x86_64",
      gpgcheck => 0,
      gpgkey   => 'http://binaries.erlang-solutions.com/debian/erlang_solutions.asc',
      enabled  => 1,
    }
  }
}
