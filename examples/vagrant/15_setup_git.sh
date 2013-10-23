# Set up git identity on the master
vagrant ssh puppet -c "sudo git config --global user.name 'Chris Hoge'"
vagrant ssh puppet -c "sudo git config --global user.email chris.hoge@puppetlabs.com"

# Copy ssh keys over to allow connection to github
mkdir my_ssh
cp ~/.ssh/* my_ssh/.
vagrant ssh puppet -c "sudo mkdir -p /.ssh; sudo cp /vagrant/my_ssh/* /.ssh/.; sudo chmod 0600 /.ssh"

# Set the new remote
vagrant ssh puppet -c "cd /etc/puppet; sudo git remote set-url origin 'git@github.com:hogepodge/openstack-deploy.git'"

