#!/bin/bash
# Set up the Puppet Master

r10k -v info puppetfile install

### The following lines get a development version of tempest that fixes glance and neutron ids
cd modules/tempest
git fetch https://review.openstack.org/stackforge/puppet-tempest refs/changes/51/86751/1 && git checkout FETCH_HEAD
cd ../..

vagrant ssh puppet -c "sudo service iptables stop; \
sudo rpm -i http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm; \
sudo yum install -y puppet-server puppetdb; \
sudo rmdir /etc/puppet/modules || sudo unlink /etc/puppet/modules; \
sudo ln -s /vagrant/modules /etc/puppet/modules; \
sudo ln -s /vagrant/site.pp /etc/puppet/manifests/site.pp; \
sudo service puppetmaster start;\
sudo puppet agent -t; \
sudo /usr/sbin/puppetdb ssl-setup; \
sudo puppet apply --modulepath /etc/puppet/modules -e \"class { '::puppetdb': listen_address => '0.0.0.0', ssl_listen_address => '0.0.0.0' } class { 'puppetdb::master::config': puppetdb_server => 'puppet'}\""
