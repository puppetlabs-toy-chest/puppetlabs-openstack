# The profile to install rabbitmq and set the firewall
class openstack::profile::rabbitmq {
  $management_address = hiera('openstack::controller::address::management')
  class { '::nova::rabbitmq':
    userid             => hiera('openstack::rabbitmq::user'),
    password           => hiera('openstack::rabbitmq::password'),
    cluster_disk_nodes => [$management_address],
    rabbitmq_class     => '::rabbitmq',
  }
}
