OSTARGET=ubuntu VAGRANTBOX="puppetlabs/ubuntu-14-x64-openstack" SCENARIO=allinone puppet apply --debug --verbose --modulepath=../tests/modules -e "include ::plostest::vagrant"
