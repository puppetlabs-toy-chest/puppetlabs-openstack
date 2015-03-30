# Make sure to refresh yum database after adding repos and before installing packages
class openstack::resources::repo::yum_refresh {
  exec { 'yum_refresh':
    command     => '/usr/bin/yum clean all',
    refreshonly => true,
  }
  Yumrepo<||> ~> Exec['yum_refresh'] -> Package<||>
}
