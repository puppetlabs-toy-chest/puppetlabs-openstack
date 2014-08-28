name    'puppetlabs-openstack'
version '4.1.0'
source 'Chris Hoge'
author 'Puppet Labs and Community Contributors'
license 'Apache License, Version 2.0'
summary 'Simplified OpenStack Icehouse Deployment with Puppet.'
description 'Using a hiera-based roles and profiles model, do simple OpenStack deployments.'
project_page 'https://github.com/puppetlabs/puppetlabs-openstack'

## OpenStack Dependencies
dependency 'puppetlabs/keystone',    '>=4.0.0 <5.0.0'
dependency 'puppetlabs/swift',       '>=4.0.0 <5.0.0'
dependency 'puppetlabs/cinder',      '>=4.0.0 <5.0.0'
dependency 'puppetlabs/glance',      '>=4.0.0 <5.0.0'
dependency 'puppetlabs/neutron',     '>=4.2.0 <5.0.0'
dependency 'puppetlabs/nova',        '>=4.0.0 <5.0.0'
dependency 'puppetlabs/heat',        '>=4.0.0 <5.0.0'
dependency 'puppetlabs/ceilometer',  '>=4.0.0 <5.0.0'
dependency 'puppetlabs/horizon',     '>=4.0.0 <5.0.0'
dependency 'puppetlabs/tempest',     '>=3.0.0 <5.0.0'

# Other Dependencies
dependency 'puppetlabs/ntp',         '>=3.0.0 <4.0.0'
dependency 'puppetlabs/firewall',    '>=1.0.0 <2.0.0'
dependency 'puppetlabs/vswitch',     '>=0.2.0 <1.0.0'
dependency 'puppetlabs/mongodb',     '>=0.6.0 <1.0.0'
dependency 'puppetlabs/mysql',       '>=2.2.0 <3.0.0'
dependency 'puppetlabs/rabbitmq',    '>=3.0.0 <4.0.0'
dependency 'puppetlabs/apache',      '>=1.0.0 <1.2.0'

# Latest sysctl is broken with 0440 permission, so pin to 0.0.1 (with 0444)
dependency 'duritong/sysctl',        '0.0.1'
