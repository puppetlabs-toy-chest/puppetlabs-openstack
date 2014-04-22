# The profile to install rabbitmq and set the firewall
class havana::profile::rabbitmq {
  class { '::nova::rabbitmq':
    userid             => hiera('openstack::rabbitmq::user'),
    password           => hiera('openstack::rabbitmq::password'),
    cluster_disk_nodes => hiera('openstack::controller::address::management'),
  }
}
