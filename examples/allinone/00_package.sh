#!/bin/sh
# This script is used for development. It packages up the working
# puppetlabs-havana development directory.
rm *gz
cd puppetlabs-havana
rm pkg/*gz
puppet module build
cp pkg/*gz ../.
cd ..
