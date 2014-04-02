#!/bin/bash
# Run tempest
vagrant ssh allinone -c "sudo /var/lib/tempest/run_tests.sh"
