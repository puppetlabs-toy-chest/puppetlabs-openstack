#!/bin/bash
# Set up the Puppet Master

vagrant ssh puppet -c "sudo apt-get update; \
sudo apt-get install -y puppetmaster; \
sudo rmdir /etc/puppet/modules || sudo unlink /etc/puppet/modules; \
sudo ln -s /vagrant/modules /etc/puppet/modules; \
sudo ln -s /vagrant/site.pp /etc/puppet/manifests/site.pp; \
sudo service puppetmaster start;\
sudo puppet agent -t;"
