This module is used to deploy a multi-node installation of OpenStack Grizzly.

#puppetlabs-grizzly

####Table of Contents

1. [Overview - What is the Grizzly module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with Grizzly](#setup)
    * [Setup Requirements](#setup-requirements)
    * [Beginning with Grizzly](#beginning-with-grizzly)
4. [Usage - Configuration and customization options](#usage)
    * [Hiera configuration](#hiera-configuration)
    * [Controller Node](#controller-node)
    * [Storage, Network, and Compute Nodes](#other-nodes)
5. [Reference - An under-the-hood peek at what the module is doing](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [License](#license)

##Overview

The Puppetlabs Grizzly module  is used to deploy a multi-node installation of OpenStack Grizzly.

##Module Description

Using the stable/grizzly branch of the puppet-openstack modules, puppetlabs-grizzly allows
for the rapid deployment of a multi-node installation of OpenStack Grizzly. Four types
of nodes are created for the deployment:

* A controller node that hosts databases, message queues and caches, and most api services.
* A storage node that hosts volumes, image storage, and the image storage api.
* A network node that performs L2 routing, L3 routing, and DHCP services.
* A compute node to run guest operating systems.

Installation and maintenace of object storage is outside the scope of this module.

##Setup

###Setup Requirements

This module assumes multiple nodes running a Red Hat 6 variant (RHEL, CentOS, or Scientific Linux).
Additionally, each node needs a minumum of two network interfaces, and up to four. The network
interfaces are divided into two groups. 

- Public interfaces:
  * API network.
  * External network.
- Internal interfaces:
  * Management network.
  * Data network.

This module have been tested with Puppet 3.3. Additionally, this module depends upon Hiera.

###Beginning with Grizzly

To begin, you will need to do some basic setup on the compute node. selinux needs to be disabled
on the compute nodes to give OpenStack full control over the KVM hypervisor and other necessary 
services. This is the only node that SELinux needs to be disabled on.

Additionally, you need to know the network addres ranges for all four of the public/private networks,
and the specific ip addresses of the controller node and the storage node.

##Usage

###Hiera Configuration
The first step to using the puppetlabs-grizzly module is to configure hiera with settings specific
to your installation. In this module, the example directory contains a sample common.yaml file
with all of the settings required by this module, as well as a example user to test your deployment
with. These configuration options include network settings, locations of specific nodes, and
passwords for Keystone and databases. If any of these settings are undefined or not properly set, your
deployment may fail.

###Controller Node
For your controller node, you need to assign your node the controller role. For example:

```
node 'control.localdomain' {
  include ::grizzly::role::controller
}
```

It's important to apply this configuration to the controller node before any of the other
nodes are applied. The other nodes depend upon the service and database setup in the controller
node.

###Other Nodes

For the remainder nodes, there are roles to assign for each. For example:
```
node 'storage.localdomain' {
  include ::grizzly::role::storage
}

node 'network.localdomain' {
  include ::grizzly::role::network
}

node /compute[0-9]+.localdomain/ {
  include ::grizzly::role::compute
}
```

For this deployment, it's assumed that there is only one storage node and one network
node. There may be multiple compute nodes.

After applying the configuration to the controller node, apply the remaining
configurations to the worker nodes. 

You will need to reboot all of the nodes after installation to ensure that the kernel
module that provides network namespaces, required by Open VSwitch, is loaded.

##Reference

The puppetlabs-grizzly module is built on the 'Roles and Profiles' pattern. Every node
in a deployment is assigned a single role. Every role is composed of some number of
profiles, which ideally should be independent of one another, allowing for composition
of new roles. The puppetlabs-grizzly module does not strictly adhere to this pattern,
but should serve as a useful example of how to build profiles from modules for customized
and maintainable OpenStack deployments.

##Limitations

This module is only tested with RedHat based operating systems.

High availability and SSL-enabled endpoints are not provided by this module.

Due to a bug in the Firewall module, some configurations may not be
applied correctly. The workaround is to flush the firewall rules and shut down
the firewall before a run.

```
iptables -F
iptables -F -t nat
service iptables stop
```

Addressing these limitations is planned for the forthcoming puppet-havana module.

##License
Puppet Grizzly Module - Puppet module for multi-node OpenStack Grizzly installation

Copyright (C) 2013 Puppet Labs, Inc.
Copyright (C) 2013 Christian Hoge

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
