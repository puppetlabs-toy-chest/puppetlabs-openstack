class grizzly::profile::firewall {
  class { '::grizzly::profile::firewall::pre': } ->
  class { '::grizzly::profile::firewall::puppet': } ->
  class { '::grizzly::profile::firewall::post': }
}
