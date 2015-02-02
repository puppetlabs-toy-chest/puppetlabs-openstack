OSTARGET=rhel VAGRANTBOX="centos-7-64-openstack" SCENARIO=integrated puppet apply --modulepath=../tests/modules -e "include ::plostest::vagrant"
