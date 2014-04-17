#!/bin/bash
# Run tempest
vagrant ssh tempest -c "sudo /var/lib/tempest/run_tests.sh -s"
