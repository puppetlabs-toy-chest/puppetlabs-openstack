#!/bin/bash
# Set up the Puppet Master

vagrant ssh puppet -c "cat > setuppuppet.sh <<EOF
#!/bin/bash
service iptables stop
\curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install 2.0.0
rvm use 2.0.0
gem install puppet --no-ri --no-rdoc
useradd puppet
EOF"
vagrant ssh puppet -c "chmod +x setuppuppet.sh; \
sudo ./setuppuppet.sh; \
sudo su - root -c 'puppet master'; \
sudo su - root -c 'puppet agent -t';
sudo rmdir /etc/puppet/modules || sudo unlink /etc/puppet/modules; \
sudo ln -s /vagrant/modules /etc/puppet/modules; \
sudo ln -s /vagrant/site.pp /etc/puppet/manifests/site.pp;"
