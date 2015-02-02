# The profile to install an OpenStack specific MongoDB server
class openstack::profile::mongodb {
  $management_network = $::openstack::config::network_management
  $inferred_address = ip_for_network($management_network)
  $explicit_address = $::openstack::config::controller_address_management

  if $inferred_address != $explicit_address {
    fail("MongoDB setup failed. The inferred location of the database based on the
    openstack::network::management hiera value is ${inferred_address}. The
    explicit address from openstack::controller::address::management
    is ${explicit_address}. Please correct this difference.")
  }

  class { '::mongodb::server':
    bind_ip     => ['127.0.0.1', $::openstack::config::controller_address_management],
    pidfilepath => '/var/run/mongodb/mongod.pid',
  }

  #exec { '/bin/systemctl daemon-reload': 
  #  before => Service['mongod']
  #}

  #file { '/usr/lib/systemd/system/mongod.service':
  #  source => 'puppet:///modules/openstack/mongod.service',
  #  owner  => root,
  #  group  => root,
  #  mode   => '0644',
  #  before => Service['mongod'],
  #  notify => Exec['/bin/systemctl daemon-reload']
  #}

  class { '::mongodb::client': }
}
