class grizzly::role::storage inherits role {
  include firewall::pre
  include profile::glance::api
  include profile::cinder::volume
  include firewall::post
}
