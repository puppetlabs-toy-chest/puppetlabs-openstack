# The profile to set up a quantum ovs network router
class grizzly::profile::quantum::router {
  class {'grizzly::profile::quantum::common':
    is_router => true,
  }

  sysctl { "net.ipv4.ip_forward":
    ensure => present,
    value  => "1",
  }
}
