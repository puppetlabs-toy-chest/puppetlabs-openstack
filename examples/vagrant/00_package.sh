#!/bin/sh
rm *gz
cd puppetlabs-havana
rm pkg/*gz
puppet module build
cp pkg/*gz ../.
cd ..
