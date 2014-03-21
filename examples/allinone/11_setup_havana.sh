#!/bin/bash
# Mount the Havana module on the Puppet Master
vagrant ssh puppet -c "sudo ln -s /havana /etc/puppet/modules; \
sudo ln -s /havana/examples/hiera.yaml /etc/puppet/hiera.yaml; \
sudo mkdir -p /etc/puppet/hieradata; \
sudo ln -s /havana/examples/allinone.yaml /etc/puppet/hieradata/common.yaml; \
sudo service puppetmaster restart;"
