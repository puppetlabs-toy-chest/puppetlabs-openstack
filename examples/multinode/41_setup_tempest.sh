#!/bin/bash
# Set up the tempest box
vagrant up tempest --provider vmware_fusion
vagrant ssh tempest -c "sudo puppet agent -t"
vagrant ssh puppet -c "sudo puppet cert sign --all"
vagrant ssh tempest -c "sudo puppet agent -t"
