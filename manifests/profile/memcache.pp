# The profile to install a local instance of memcache
class grizzly::profile::memcache {
  class { 'memcached':
    listen_ip => '127.0.0.1',
    tcp_port  => '11211',
    udp_port  => '11211',
  }
}
