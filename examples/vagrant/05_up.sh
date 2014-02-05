#!/bin/bash
vagrant up --provider vmware_fusion puppet control storage network compute
cp ../hiera.yaml ../common.yaml .
