# The profile to install rabbitmq and set the firewall
class openstack::profile::rabbitmq {
  $management_address = $::openstack::config::controller_address_management

  if $::osfamily == 'RedHat' {
	  package { 'erlang':
	    ensure  => installed,
	    before  => Package['rabbitmq-server'],
	    require => Yumrepo['erlang-solutions'],
	  }
  }

  class { '::nova::rabbitmq':
    userid             => $::openstack::config::rabbitmq_user,
    password           => $::openstack::config::rabbitmq_password,
    cluster_disk_nodes => [$management_address],
    rabbitmq_class     => '::rabbitmq',
  }
}
