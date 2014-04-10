class openstack::setup::cirros {
  glance_image { 'Cirros':
    ensure           => present,
    name             => 'Cirros',
    is_public        => 'yes',
    container_format => 'bare',
    disk_format      => 'qcow2',
    source           => 'http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img',
  }
}
