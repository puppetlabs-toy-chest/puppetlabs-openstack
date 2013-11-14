# The profile to install rabbitmq and set the firewall
class havana::profile::rabbitmq {
  class { '::nova::rabbitmq':
    userid   => hiera('havana::rabbitmq::user'),
    password => hiera('havana::rabbitmq::password'),
  }
}
