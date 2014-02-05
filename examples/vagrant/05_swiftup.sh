#!/bin/bash
vagrant up --provider vmware_fusion puppet control swiftstore1 swiftstore2 swiftstore3
cp ../hiera.yaml ../common.yaml .
