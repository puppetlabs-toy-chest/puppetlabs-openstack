class grizzly::role::storage inherits role {
  include firewall::pre
  include profile::glance::registry
  include profile::cinder::volume
  include firewall::post
}
