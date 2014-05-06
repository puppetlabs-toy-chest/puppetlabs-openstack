#!/bin/bash
./00_download_modules.sh
./05_up.sh
./10_setup_master.sh
./11_setup_havana.sh
./20_setup_nodes.sh
./30_deploy_control.sh
./40_deploy_nodes.sh
