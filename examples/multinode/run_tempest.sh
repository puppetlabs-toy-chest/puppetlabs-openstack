#!/bin/bash

/var/lib/tempest/run_tests.sh -s 2>&1 | tee /tmp/tempestoutput
grep "ERROR: test suite for <class '" /tmp/tempestoutput 2>&1 | tee /tmp/errors

if [ "$(diff /tmp/errors /openstack/examples/multinode/exclusion.txt)" == "" ]
then
  echo "all non-excluded tests passed"
  exit 0
else
  exit 1
fi
