class grizzly::role::network inherits role {
  include firewall::pre
  include profile::quantum::router
  include profile::quantum::agent
  include firewall::post
}
