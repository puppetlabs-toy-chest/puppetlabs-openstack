#!/bin/bash

# Remainder of nodes follow
vagrant ssh network -c "sudo puppet agent -t"
vagrant ssh storage -c "sudo puppet agent -t"
vagrant ssh compute -c "sudo puppet agent -t"

wait
