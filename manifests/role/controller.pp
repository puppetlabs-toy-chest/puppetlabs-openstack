class havana::role::controller inherits ::havana::role {
  class { '::havana::profile::rabbitmq': } ->
  class { '::havana::profile::memcache': } ->
  class { '::havana::profile::mysql': } ->
  class { '::havana::profile::keystone': } ->
  class { '::havana::profile::glance::auth': } ->
  class { '::havana::profile::cinder::api': } ->
  class { '::havana::profile::nova::api': } ->
  class { '::havana::profile::quantum::server': } ->
  class { '::havana::profile::horizon': }
  class { '::havana::profile::auth_file': }
}
