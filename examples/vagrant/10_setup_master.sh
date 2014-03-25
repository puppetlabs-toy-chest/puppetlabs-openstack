#!/bin/bash
# Set up the Puppet Master

vagrant ssh puppet -c "sudo service iptables stop; \
sudo rpm -i http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm; \
sudo yum install -y puppet-server; \
sudo yum install -y git; \
sudo rmdir /etc/puppet/modules; \
sudo ln -s /vagrant/modules /etc/puppet/modules; \
sudo ln -s /vagrant/site.pp /etc/puppet/manifests/site.pp; \
sudo gem install librarian-puppet --no-ri --no-rdoc; \
cd /vagrant; \
sudo librarian-puppet install --verbose --path /vagrant/modules; \
sudo service puppetmaster start;\
sudo puppet agent -t; \
sudo puppet apply --modulepath /etc/puppet/modules -e \"class { '::puppetdb': listen_address => '0.0.0.0', ssl_listen_address => '0.0.0.0' } class { 'puppetdb::master::config': puppetdb_server => 'puppet'}\""
