# The profile to install rabbitmq and set the firewall
class grizzly::profile::rabbitmq {
  class { '::nova::rabbitmq':
    userid   => hiera('grizzly::rabbitmq::user'),
    password => hiera('grizzly::rabbitmq::password'),
  }
}
