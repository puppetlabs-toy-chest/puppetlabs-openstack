class openstack::resources::repo::epel {
  if ($::osfamily == 'RedHat' and
      $::operatingsystem != 'Fedora' and
      $::operatingsystemmajrelease >= 6) {
    include openstack::resources::repo::yum_refresh

    include ::epel
  }
}
