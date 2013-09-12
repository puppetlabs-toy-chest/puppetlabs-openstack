# The profile to set up a quantum ovs network router
class grizzly::profile::quantum::router {
  class {'grizzly::profile::quantum::common':
    is_router => true,
  }
}
