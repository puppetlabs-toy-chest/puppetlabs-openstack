#!/bin/bash
./00_download_modules.sh
./05_up.sh
./10_setup_master.sh
./11_setup_openstack.sh
./20_setup_node.sh
./30_deploy.sh
