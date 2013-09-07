class grizzly::role::network inherits role {
  include firewall::pre
  include profile::quantum::router
  include profile::quantum::agent
  include profile::quantum::server
  include firewall::post
}
