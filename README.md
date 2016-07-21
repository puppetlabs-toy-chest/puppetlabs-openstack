#puppetlabs-openstack
Puppet Labs Reference and Testing Deployment Module for OpenStack.

Version 8.0.0 / 2016.1 / Mitaka / The hogepodge Fork

####Table of Contents

1. [Overview - What is the puppetlabs-openstack module?](#overview)
   * [Why a fork?](#forked)
2. [A Note on Versioning](#versioning)
2. [Module Description - What does the module do?](#module-description)
3. [Quick Start - Up and Running with VMWare Fusion and Vagrant](#quickstart)
4. [Setup - The basics of getting started with OpenStack](#setup)
    * [Setup Requirements](#setup-requirements)
    * [Beginning with OpenStack](#beginning-with-openstack)
5. [Usage - Configuration and customization options](#usage)
    * [Hiera configuration](#hiera-configuration)
    * [Controller Node](#controller-node)
    * [Storage, Network, and Compute Nodes](#other-nodes)
6. [Reference - An under-the-hood peek at what the module is doing](#reference)
7. [Limitations - OS compatibility, etc.](#limitations)
8. [License](#license)

##Overview

The puppetlabs-openstack module is used to deploy a multi-node, all-in-one, or swift-only installation of
OpenStack. The module does not build out a high-availability or SSL secured cluster, and should be
regarded as a learning and testing tool, similar to devstack. My own use of this module was previously for
puppet-openstack development, and is now used for demos and interoperability testing.

###Forked

I was the original author of this module, and am to blame for nearly all of its bugs and
oddities. Please do not use it for production work. It might be a start, but there is so
much more that you would be missing my using it. Also, it's a bit weird. I was trying
to get my head around some ideas of node management and code encapsulation using Puppet,
and while I got a number of things right, and came up with some clever hacks for
Puppet shortcomings, I also got some things wrong. Rearchitechting is a task
left to someone else, and there is probably a better solution out there already.

Why a fork? While I no longer maintain the upstream module (indeed, who really does any
more?), I still have need for a flexible, non-devstack way to deploy stable OpenStack
releases for demonstrations and testing. Mosly I'm interested in understanding the
DefCore test suite so I can offer help on configuration, execution, and updating of the
OpenStack Tempest tests that target DefCore. As such, this fork is biased towards building
out a working test platform. Some branches may including working materials such as
RefStack result pages so I can track the progress of the module as I work out bugs and
misconfigurations.

I generally let the upstream managers know what I'm up to and they are free to crib from
my work, but maintaing a general-purpose module is outside of the scope of my work and
goals.

I have a goal of swapping this module out for something else that will do a similar source-based
deployment of OpenStack. Don't hold your breath for it, though. The Puppet OpenStack modules,
for all their quirks and dependence on vendor packaging, tend to get the job done.

##Versioning

The versioning for the hogepodge/puppet-openstack modules is a follows: 

```
Puppet Module :: OpenStack Version :: OpenStack Codename
2.0.0         -> 2013.1.0          -> Grizzly
3.0.0         -> 2013.2.0          -> Havana
4.0.0         -> 2014.1.0          -> Icehouse
5.0.0         -> 2014.2.0          -> Juno
6.0.0         -> 2015.1.0          -> Kilo
7.0.0         -> 2015.2.0          -> Liberty
8.0.0         -> 2016.1.0          -> Mitaka
9.0.0         -> 2016.2.0          -> Newton 
```

##Module Description

Using the master branch of the puppet-openstack modules, puppetlabs-openstack allows
for the rapid deployment of an installation of OpenStack. For the multi-node, up to five
types of nodes are created for the deployment:

* A controller node that hosts databases, message queues and caches, and most api services.
* A storage node that hosts volumes, image storage, and the image storage api.
* A network node that performs L2 routing, L3 routing, and DHCP services.
* A compute node to run guest operating systems.
* An optional Tempest node to test your deployment.

The all-in-one deployment sets up all of the services on a single node,
including the Tempest testing.

The Swift deployment sets up:

* A controller node that hosts databases, message queues and caches, and the Swift API.
* Three storage nodes in different Swift Zones.

##QuickStart

###Requirements

To run the integrated testing infrastructure you need the following requirements on your workstation:

* VMWare Fusion/Desktop, with the network set to not require authentication for "promiscuous mode"
* Vagrant plugin for VMWare Fusion/Desktop.
* Puppet 3.x (`sudo gem install puppet`)
* A CentOS 7 minimal image, loaded into Vagrant with the name 'centos-7-64-openstack'
  (or something thereabouts)

Start by creating a working test system in the examples directory:

```
cd examples
./make_rhel_allinone.sh
```

That script will execute a set of Puppet modules to build out a Red Hat based all-in-one
test environment. Change into that environment, and start running the scripts in order:

```
cd rhel_allinone
# Begin by downloading dependencies from GitHub
./10_download_modules.sh

# Now start the Vagrant environment and configure networking
./20_up.sh

# Set up the Puppet Master node
./30_setup_master.sh

# Set up the openstack modules on the Puppet Master
./40_setup_openstack.sh

# Connect all of the nodes to the Puppet Master and sign certs
./50_setup_nodes.sh

# Deploy the control node first
./60_deploy_control.sh

# Deploy the rest of the cluter nodes
./70_deploy_nodes.sh
```

If the Puppet runs complete successfully, you should be able to access the Horizon
interface on the controller node. The address of the node is at the top of the
`addresses.yaml` file.

Once you're evaluating and working with the system you can bring the entire cluster
down with the final script:

```
# Have Vagrant tear down the nodes
./80_destroy_nodes.sh
```

##Setup

###Setup Requirements

This module assumes nodes running on a RedHat 7 variant (RHEL, CentOS, or Scientific Linux) with
Puppet. Each node needs a minimum of two network interfaces, and up to four. The network interfaces
are divided into two groups.

- Public interfaces:
  * API network.
  * External network.
- Internal interfaces:
  * Management network.
  * Data network.

This module have been tested with Puppet 3.whatever. I'm sure it breaks badly on 4.
This module depends upon Hiera. Object store support (Swift) depends upon exported
resources and PuppetDB.

The base image must use iptables instead of firewalld. I've added code to install it.

###Beginning with OpenStack

To begin, you will need to do some basic setup on the compute node. SElinux needs to be disabled
on the compute nodes to give OpenStack full control over the KVM hypervisor and other necessary 
services. This is the only node that SELinux needs to be disabled on.

Additionally, you need to know the network address ranges for all four of the public/private networks,
and the specific ip addresses of the controller node and the storage node. Keep in mind that your
public networks can overlap with one another, as can the private networks.

If you are running VMWare Fusion, and Vagrant with the Fusion provider, please contact
me (chris@openstack.org) for a CentOS 7 image if you need one to help you get started.

##Usage

###Hiera Configuration
The first step to using the puppetlabs-openstack module is to configure hiera with settings specific
to your installation. In this module, the example directory contains sample common.yaml (for multi-node)
and allinone.yaml (for all-in-one) files with all of the settings required by this module, as well as an
example user and networks to test your deployment with. These configuration options include network settings,
locations of specific nodes, and passwords for Keystone and databases. If any of these settings are
undefined or not properly set, your deployment may fail.

###Controller Node
For your controller node, you need to assign your node the controller role. For example:

```
node 'control.localdomain' {
  include ::openstack::role::controller
}
```

It's important to apply this configuration to the controller node before any of the other
nodes are applied. The other nodes depend upon the service and database setup in the controller
node.

###Other Nodes

For the remainder nodes, there are roles to assign for each. For example:
```
node 'storage.localdomain' {
  include ::openstack::role::storage
}

node 'network.localdomain' {
  include ::openstack::role::network
}

node /compute[0-9]+.localdomain/ {
  include ::openstack::role::compute
}
```

For this deployment, it's assumed that there is only one storage node and one network
node. There may be multiple compute nodes.

After applying the configuration to the controller node, apply the remaining
configurations to the worker nodes. 

You will need to reboot all of the nodes after installation to ensure that the kernel
module that provides network namespaces, required by Open VSwitch, is loaded.

### Object Store Nodes

Begin by setting up PuppetDB. The easiest way to do this is to use the module provided
by Puppet Labs. The module only needs to be installed on the master, and should be
used after the agent on the master has connected to itself. For example, you can do a
complete installation with the following commands:

```
# connect the puppet master to itself for a first run

sudo puppet agent -t

# install the PuppetDB module
sudo puppet module install puppetlabs/puppetdb

# install the module on the puppet master node
sudo puppet apply --modulepath /etc/puppet/modules -e \"class { '::puppetdb': listen_address => '0.0.0.0', ssl_listen_address => '0.0.0.0' } class { 'puppetdb::master::config': puppetdb_server => 'puppet'}\""
```

You will need to create three nodes as object stores for Swift, assigning three zones:

```
node /swift[0-9]+zone1.localdomain/ {
  class { '::openstack::role::swiftstorage':
    zone => '1',
  }

node /swift[0-9]+zone2.localdomain/ {
  class { '::openstack::role::swiftstorage':
    zone => '2',
  }

node /swift[0-9]+zone3.localdomain/ {
  class { '::openstack::role::swiftstorage':
    zone => '3',
  }
```

Because of the use of exported resources, puppet will need multiple runs to converge. First run the Puppet Agent
on all of the Swift nodes, which will build out the basic storage and store the exported resource information
in PuppetDB. Then run the agent on the control node, which will build out the ring files required by Swift.
Finally, run Puppet against the Swift storage nodes again to copy the ring files over and successfully start
the Swift services.

##Reference

The puppetlabs-openstack module is built on the 'Roles and Profiles' pattern. Every node
in a deployment is assigned a single role. Every role is composed of some number of
profiles, which ideally should be independent of one another, allowing for composition
of new roles. The puppetlabs-openstack module does not strictly adhere to this pattern,
but should serve as a useful example of how to build profiles from modules for customized
and maintainable OpenStack deployments.

##Limitations

* High availability and SSL-enabled endpoints are not provided by this module.


##License
hogepodge, I mean, Puppet Labs OpenStack - A Puppet Module for a Multi-Node OpenStack Mitaka Installation.
Say that ten times fast.

Copyright (C) 2013, 2014, 2015, 2016 Puppet, Inc. and Christian Hoge

Original Author - Christian Hoge

Puppet Labs can be contacted at: info@puppetlabs.com
Chris Hoge can be contacted at: chris@openstack.org

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
