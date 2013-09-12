# The profile to install the volume service
class grizzly::profile::cinder::volume {
  class { 'grizzly::profile::cinder::common':
    is_volume => true,
  }
}
