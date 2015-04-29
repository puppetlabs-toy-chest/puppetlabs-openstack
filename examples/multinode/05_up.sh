#!/bin/bash
# This is the script for bringing up the standard openstack nodes without
# Swift. This is probably the up script you want to run.
vagrant up --provider virtualbox puppet control storage network compute
