# plostest

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with plostest](#setup)
    * [What plostest affects](#what-plostest-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with plostest](#beginning-with-plostest)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This is a helper module within the puppetlabs-openstack project designed to set
up test environments within the puppetlabs-openstack test matrix. At this point
it is not indended to be run on a Puppet Master. Rather, it should be used in
masterless mode (puppet apply -t) to set up a Vagrant test environment using
environment variables to configure the target.

## Module Description

The original releases of puppetlabs-openstack included example environments to
deploy a variety of configurations across Vagrant driven VMWare Fusion virtual
machines. As the target environment grew and was being managed my manually
editing scripts, it was clear that a more automated solution was necessary. This
project is an attempt to use Puppet to realize the test matrix across the following
variables:

* SCENARIO: the type of OpenStack deployment you want. This includes variants like
allinone, multinode, and swift.
* OS: the family of operating system to target. Currently we target Red Hat (rhel)
and Ubuntu (ubuntu) based systems.
* VAGRANTBOX: any Vagrant box of the user's choosing to target.
* SOURCE: The source of the Puppet OpenStack module suite to pull from. Choices
include forge (for latest released), master (for Git Hub master), or a stable
Git Hub branch.

## Setup and Usage

### What plostest affects

* This module will create or overwrite a test directory for the specified
scenario.

### Setup Requirements

This module requires running Puppet locally in masterless mode. It is meant
to be used with the puppetlabs-openstack project.

### Beginning with plostest

This module should be run in masterless mode. All of the environment variables should
be set, and there is little to no error checking yet.

```
SCENARIO=allinone \
OS=rhel \
VAGRANTBOX="puppetlabs/centos-65-x64-openstack" \
SOURCE=master \
puppet apply \
--modulepath=/Users/hoge/puppetlabs-openstack/tests/modules \
-e "include ::plostest::vagrant"
```

This will create a new directory with a Vagrantfile and test script to build out
a working OpenStack environment.


## Limitations

For use with the puppetlabs-openstack module with Red Hat or Ubuntu systems.

## Development

Development is being driven by internal testing needs. Contributions will be
considered.

## Release Notes/Contributors/Etc **Optional**

Thanks to ashp, hunner, and finch all of their help in building out this work.
