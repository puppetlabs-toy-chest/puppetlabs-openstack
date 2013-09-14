class grizzly::role::network inherits role {
  include firewall::pre
  include profile::quantum::router
  #include firewall::post
}
