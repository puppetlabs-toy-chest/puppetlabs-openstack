class openstack::setup::cirros {
  glance_image { 'Cirros1':
    ensure           => present,
    name             => 'Cirros 0.3.4-1',
    is_public        => 'yes',
    container_format => 'bare',
    disk_format      => 'qcow2',
    source           => 'http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img',
  }

  glance_image { 'Cirros2':
    ensure           => present,
    name             => 'Cirros 0.3.4-2',
    is_public        => 'yes',
    container_format => 'bare',
    disk_format      => 'qcow2',
    source           => 'http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img',
  }

  Anchor['keystone-users'] -> Glance_image<||> 
}
