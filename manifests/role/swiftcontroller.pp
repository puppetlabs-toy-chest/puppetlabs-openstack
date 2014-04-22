class havana::role::swiftcontroller inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::rabbitmq': } ->
  class { '::havana::profile::memcache': } ->
  class { '::havana::profile::mysql': } ->
  class { '::havana::profile::keystone': } ->
  class { '::havana::profile::swift::proxy': }
  class { '::havana::profile::horizon': }
  class { '::havana::profile::auth_file': }
}
