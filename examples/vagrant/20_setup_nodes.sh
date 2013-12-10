#!/bin/bash

# Connect the agents to the master
vagrant ssh control -c "sudo puppet agent -t"
vagrant ssh network -c "sudo puppet agent -t"
vagrant ssh storage -c "sudo puppet agent -t"
vagrant ssh compute -c "sudo puppet agent -t"

# sign the certs
vagrant ssh puppet -c "sudo puppet cert sign --all"
