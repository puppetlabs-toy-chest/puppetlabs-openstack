#!/bin/bash

# Kick off the puppet runs, control is first for databases
vagrant ssh allinone -c "sudo puppet agent -t"
