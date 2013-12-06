#!/bin/sh
rm *gz
cd ../../
rm pkg/*gz
puppet module build
cp pkg/*gz examples/vagrant/.
