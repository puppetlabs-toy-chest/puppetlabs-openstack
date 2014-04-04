#!/bin/bash
# Run tempest
vagrant ssh control -c "sudo /var/lib/tempest/run_tests.sh"
