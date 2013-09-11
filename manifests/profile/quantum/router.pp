# The profile to set up a quantum ovs network router
class grizzly::profile::quantum::router {
  notify { 'TODO: quantum::router profile': }

  $data_device = hiera('grizzly::network::data::device')
  $data_address = getvar("ipaddress_${data_device}")

  $controller_address = hiera('grizzly::controller::address::management')

  class { '::quantum':
    rabbit_host        => $controller_address,
    rabbit_user        => hiera('grizzly::rabbitmq::user'),
    rabbit_password    => hiera('grizzly::rabbitmq::password'),
    debug              => hiera('grizzly::quantum::debug'),
    verbose            => hiera('grizzly::quantum::verbose'),
  }

  class { '::quantum::agents::ovs':
    enable_tunneling => 'True',
    local_ip         => $data_address,
    enabled          => true,
  }

  class { '::quantum::agents::l3':
    debug          => hiera('grizzly::quantum::debug'),
  }

  class { '::quantum::agents::dhcp':
    debug          => hiera('grizzly::quantum::debug'),
  }

  class { '::quantum::agents::metadata':
    auth_password => hiera('grizzly::quantum::password'),
    shared_secret => hiera('grizzly::quantum::shared_secret'),
    auth_url      => "http://${controller_address}:35357/v2.0",
    debug         => hiera('grizzly::quantum::debug'),
  }
}
