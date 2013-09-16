# The profile to install a local instance of memcache
class grizzly::profile::memcache {

  firewall { '11211 - memcached - Management Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '11211',
    source => hiera('grizzly::network::management'),
  }

  firewall { '11211 - memcached - API Network':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '11211',
    source => hiera('grizzly::network::api'),
  }

  class { 'memcached':
    listen_ip => hiera('grizzly::controller::address::management'), #'127.0.0.1',
    tcp_port  => '11211',
    udp_port  => '11211',
  }
}
