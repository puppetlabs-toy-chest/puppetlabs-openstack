class openstack::role::swiftcontroller inherits ::openstack::role {
  class { '::openstack::profile::firewall': }
  class { '::openstack::profile::rabbitmq': } ->
  class { '::openstack::profile::memcache': } ->
  class { '::openstack::profile::mysql': } ->
  class { '::openstack::profile::keystone': } ->
  class { '::openstack::profile::swift::proxy': }
  class { '::openstack::profile::horizon': }
  class { '::openstack::profile::auth_file': }
  class { '::openstack::profile::nova::api': }
}
