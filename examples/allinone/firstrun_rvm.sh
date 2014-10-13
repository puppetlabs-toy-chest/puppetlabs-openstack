#!/bin/bash
./00_download_modules.sh
./05_up.sh
./10_setup_master_rvm.sh
./11_setup_openstack_rvm.sh
./20_setup_node_rvm.sh
./30_deploy.sh
