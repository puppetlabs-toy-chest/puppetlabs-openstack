OSTARGET=ubuntu VAGRANTBOX=ubuntu-14-64 SCENARIO=allinone puppet apply --modulepath=../tests/modules -e "include ::plostest::vagrant"
