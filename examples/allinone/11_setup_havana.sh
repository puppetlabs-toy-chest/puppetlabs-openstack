#!/bin/bash
# Mount the OpenStack module on the Puppet Master
vagrant ssh puppet -c "sudo ln -s /openstack /etc/puppet/modules; \
sudo ln -s /openstack/examples/hiera.yaml /etc/puppet/hiera.yaml; \
sudo mkdir -p /etc/puppet/hieradata; \
sudo ln -s /openstack/examples/allinone.yaml /etc/puppet/hieradata/common.yaml; \
sudo service puppetmaster restart;"
