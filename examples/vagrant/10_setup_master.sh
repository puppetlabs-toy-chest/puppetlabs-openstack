#!/bin/bash
# Set up the Puppet Master

vagrant ssh puppet -c "sudo service iptables stop; \
sudo puppet module install puppetlabs/puppetdb; \
sudo puppet module install puppetlabs/ntp; \
sudo puppet module install puppetlabs/mysql --version 0.6.1; \
sudo puppet module install puppetlabs/openstack; \
sudo puppet module install puppetlabs/mongodb; \
sudo cp /vagrant/site.pp /etc/puppet/manifests/site.pp; \
sudo chown root:puppet /etc/puppet/manifests/site.pp; \
sudo service puppetmaster start;\
sudo puppet agent -t; \
sudo puppet apply --modulepath /etc/puppet/modules -e \"class { '::puppetdb': listen_address => '0.0.0.0', ssl_listen_address => '0.0.0.0' } class { 'puppetdb::master::config': puppetdb_server => 'puppet'}\""
