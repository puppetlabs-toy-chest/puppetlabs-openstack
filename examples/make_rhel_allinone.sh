OSTARGET=rhel VAGRANTBOX="puppetlabs/centos-65-x64-openstack" SCENARIO=allinone puppet apply --modulepath=../tests/modules -e "include ::plostest::vagrant"
