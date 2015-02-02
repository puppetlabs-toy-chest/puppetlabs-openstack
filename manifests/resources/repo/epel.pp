class openstack::resources::repo::epel {
  if ($::osfamily == 'RedHat' and
      $::operatingsystem != 'Fedora' and
      $::operatingsystemrelease =~ /^7\..*$/) {
    include openstack::resources::repo::yum_refresh

    include ::epel
    # Yumrepo['epel'] -> Package<||>
  }
}
