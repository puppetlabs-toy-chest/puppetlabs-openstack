# The profile to install rabbitmq and set the firewall
class grizzly::profile::rabbitmq {
  class { '::nova::rabbitmq':
    userid   => hiera('grizzly::rabbitmq::user'),
    password => hiera('grizzly::rabbitmq::password'),
  }

  firewall { '5672 - RabbitMQ Management':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '5672',
    source => hiera('grizzly::network::management'),
  }
}
