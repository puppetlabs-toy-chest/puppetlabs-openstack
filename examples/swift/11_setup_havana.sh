#!/bin/bash
# Mount the openstack module on the Puppet Master
vagrant ssh puppet -c "sudo ln -s /openstack /etc/puppet/modules; \
sudo ln -s /openstack/examples/hiera.yaml /etc/puppet/hiera.yaml; \
sudo mkdir -p /etc/puppet/hieradata; \
sudo ln -s /openstack/examples/common.yaml /etc/puppet/hieradata/common.yaml; \
sudo service puppetmaster restart;"
