OSTARGET=rhel VAGRANTBOX="centos-7-64-openstack-july-2016" SCENARIO=allinone puppet apply --modulepath=../tests/modules -e "include ::plostest::vagrant"
