# The profile to install a local instance of memcache
class openstack::profile::memcache {
  class { 'memcached':
    listen_ip => $::openstack::config::controller_address_management, #'127.0.0.1',
    tcp_port  => '11211',
    udp_port  => '11211',
  }
}
