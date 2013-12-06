#!/bin/bash

# Set up the Puppet Master
vagrant ssh puppet -c "sudo service iptables stop; \
sudo puppet module install puppetlabs/ntp; \
sudo puppet module install puppetlabs/firewall; \
sudo puppet module install puppetlabs/openstack --version 3.0.0-rc1; \
cd /etc/puppet/modules; \
sudo tar -xvzf /vagrant/*gz; \
sudo mv puppetlabs-havana-3.0.0 havana; \
sudo cp /vagrant/site.pp /etc/puppet/manifests/site.pp; \
sudo chown root:puppet /etc/puppet/manifests/site.pp; \
sudo cp /vagrant/hiera.yaml /etc/puppet/hiera.yaml; \
sudo chown root:puppet /etc/puppet/hiera.yaml; \
sudo mkdir /etc/puppet/hieradata; \
sudo chown root:puppet /etc/puppet/hieradata; \
sudo cp /vagrant/common.yaml /etc/puppet/hieradata/common.yaml; \
sudo chown root:puppet /etc/puppet/hieradata/common.yaml; \
sudo service puppetmaster start;\
sudo puppet agent -t"
