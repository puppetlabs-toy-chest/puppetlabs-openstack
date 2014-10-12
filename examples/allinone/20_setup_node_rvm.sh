#!/bin/bash

# Connect the agents to the master
vagrant ssh allinone -c "sudo puppet agent -t"

# sign the certs
vagrant ssh puppet -c "sudo su - root -c 'puppet cert sign --all'"
