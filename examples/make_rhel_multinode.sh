OSTARGET=rhel VAGRANTBOX=centos-6-64 SCENARIO=multinode puppet apply --modulepath=../tests/modules -e "include ::plostest::vagrant"
