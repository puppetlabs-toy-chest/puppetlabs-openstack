#!/bin/bash
# Move the Havana module to the Puppet Master
vagrant ssh puppet -c "cd /etc/puppet/modules; \
sudo tar -xvzf /vagrant/*gz; \
sudo rm -rf havana
sudo mv puppetlabs-havana* havana; \
sudo cp /vagrant/hiera.yaml /etc/puppet/hiera.yaml; \
sudo chown root:puppet /etc/puppet/hiera.yaml; \
sudo mkdir /etc/puppet/hieradata; \
sudo chown root:puppet /etc/puppet/hieradata; \
sudo cp /etc/puppet/modules/havana/examples/common.yaml /etc/puppet/hieradata/common.yaml; \
sudo chown root:puppet /etc/puppet/hieradata/common.yaml; \
sudo service puppetmaster restart;"
