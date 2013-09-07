class grizzly::role::compute inherits role {
  include firewall::pre
  include profile::quantum::agent
  include profile::nova::compute
  include firewall::post
}
