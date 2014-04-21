#!/bin/bash

# Connect the agents to the master
vagrant ssh control -c "sudo puppet agent -t"
vagrant ssh swiftstore1 -c "sudo puppet agent -t"
vagrant ssh swiftstore2 -c "sudo puppet agent -t"
vagrant ssh swiftstore3 -c "sudo puppet agent -t"

# sign the certs
vagrant ssh puppet -c "sudo puppet cert sign --all"
