#puppetlabs-openstack
Puppet Labs Reference and Testing Deployment Module for OpenStack.
This module is used to deploy a multi-node installation of OpenStack Havana.

####Table of Contents

1. [Overview - What is the puppetlabs-openstack module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with OpenStack](#setup)
    * [Setup Requirements](#setup-requirements)
    * [Beginning with OpenStack](#beginning-with-openstack)
4. [Usage - Configuration and customization options](#usage)
    * [Hiera configuration](#hiera-configuration)
    * [Controller Node](#controller-node)
    * [Storage, Network, and Compute Nodes](#other-nodes)
5. [Reference - An under-the-hood peek at what the module is doing](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [License](#license)

##Overview

The puppetlabs-openstack module is used to deploy a multi-node or all-in-one installation of 
OpenStack Havana. This is a pre-release version. Bug reports and improvements leading to 
the 1.0 release are welcome.

##Module Description

Using the stable/havana branch of the puppet-openstack modules, puppetlabs-openstack allows
for the rapid deployment of an installation of OpenStack Havana. For the multi-node, four types
of nodes are created for the deployment:

* A controller node that hosts databases, message queues and caches, and most api services.
* A storage node that hosts volumes, image storage, and the image storage api.
* A network node that performs L2 routing, L3 routing, and DHCP services.
* A compute node to run guest operating systems.
* Swift nodes (three zones) that host the object store.

The all-in-one deployment sets up all of the services except for Swift on a single node.

##Setup

###Setup Requirements

This module assumes nodes running on a RedHat 6 variant (RHEL, CentOS, or Scientific Linux)
or Ubuntu LTS 12.04. Additionally, each node needs a minimum of two network interfaces, and up to four.
The network interfaces are divided into two groups.

- Public interfaces:
  * API network.
  * External network.
- Internal interfaces:
  * Management network.
  * Data network.

This module have been tested with Puppet 3.3. Additionally, this module depends upon Hiera. Object
store support (Swift) depends upon exported resources and PuppetDB.

###Beginning with OpenStack

To begin, you will need to do some basic setup on the compute node. SElinux needs to be disabled
on the compute nodes to give OpenStack full control over the KVM hypervisor and other necessary 
services. This is the only node that SELinux needs to be disabled on.

Additionally, you need to know the network addres ranges for all four of the public/private networks,
and the specific ip addresses of the controller node and the storage node.

If you are running VMWare Fusion, and Vagrant with the Fusion provider, a CentOS 6.5 image is provided
to help you get started. See the examples/vagrant and examples/allinone for details.

##Usage

###Hiera Configuration
The first step to using the puppetlabs-openstack module is to configure hiera with settings specific
to your installation. In this module, the example directory contains a sample common.yaml file
with all of the settings required by this module, as well as a example user to test your deployment
with. These configuration options include network settings, locations of specific nodes, and
passwords for Keystone and databases. If any of these settings are undefined or not properly set, your
deployment may fail.

###Controller Node
For your controller node, you need to assign your node the controller role. For example:

```
node 'control.localdomain' {
  include ::havana::role::controller
}
```

It's important to apply this configuration to the controller node before any of the other
nodes are applied. The other nodes depend upon the service and database setup in the controller
node.

###Other Nodes

For the remainder nodes, there are roles to assign for each. For example:
```
node 'storage.localdomain' {
  include ::havana::role::storage
}

node 'network.localdomain' {
  include ::havana::role::network
}

node /compute[0-9]+.localdomain/ {
  include ::havana::role::compute
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
  class { '::havana::role::swiftstorage':
    zone => '1',
  }

node /swift[0-9]+zone2.localdomain/ {
  class { '::havana::role::swiftstorage':
    zone => '2',
  }

node /swift[0-9]+zone3.localdomain/ {
  class { '::havana::role::swiftstorage':
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

High availability and SSL-enabled endpoints are not provided by this module.

Due to a bug in the Firewall module, some configurations may not be
applied correctly. The workaround is to flush the firewall rules and shut down
the firewall before a run.

```
iptables -F
iptables -F -t nat
service iptables stop
```

Addressing these limitations is planned for the forthcoming puppetlabs-openstack module.

##License
Puppet Labs Havana - A Puppet Module for a Multi-Node OpenStack Havana Installation.

Copyright (C) 2013, 2014 Puppet Labs, Inc.
Original Author - Christian Hoge

Puppet Labs can be contacted at: info@puppetlabs.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
