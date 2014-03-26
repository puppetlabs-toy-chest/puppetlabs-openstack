class havana::role::controller inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::rabbitmq': } ->
  class { '::havana::profile::memcache': } ->
  class { '::havana::profile::mysql': } ->
  class { '::havana::profile::mongodb': } ->
  class { '::havana::profile::keystone': } ->
  class { '::havana::profile::ceilometer::api': } ->
  class { '::havana::profile::glance::auth': } ->
  class { '::havana::profile::cinder::api': } ->
  class { '::havana::profile::swift::proxy': } ->
  class { '::havana::profile::nova::api': } ->
  class { '::havana::profile::neutron::server': } ->
  class { '::havana::profile::heat::api': } ->
  class { '::havana::profile::horizon': }
  class { '::havana::profile::auth_file': }
  class { '::havana::profile::tempest': }
}
