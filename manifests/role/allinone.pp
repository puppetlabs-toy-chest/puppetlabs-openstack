class havana::role::allinone inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::rabbitmq': }
  class { '::havana::profile::memcache': }
  class { '::havana::profile::mysql': }
  class { '::havana::profile::mongodb': }
  class { '::havana::profile::keystone': } 
  class { '::havana::profile::ceilometer::agent': }
  class { '::havana::profile::ceilometer::api': }
  class { '::havana::profile::glance::api': }
  class { '::havana::profile::glance::auth': }
  class { '::havana::profile::cinder::volume': }
  class { '::havana::profile::cinder::api': }
  class { '::havana::profile::nova::compute': }
  class { '::havana::profile::nova::api': }
  class { '::havana::profile::neutron::router': }
  class { '::havana::profile::neutron::server': }
  class { '::havana::profile::heat::api': }
  class { '::havana::profile::horizon': }
  class { '::havana::profile::auth_file': }

  # upload a glance image, just because
  glance_image { 'cirros':
    ensure           => present,
    name             => 'Cirros',
    is_public        => 'yes',
    container_format => 'bare',
    disk_format      => 'qcow2',
    source           => 'http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img',
  }
}
