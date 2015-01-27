##2015-01-26 - Release 5.0.2
###Summary

This is an emergency bugfix release to fix the use of parameters that
were unexpectedly removed in the stable nova branch, plus a number of
other bugfixes.

####Bugfixes
- Fix syntax error in example hiera file
- Fix Puppetfile dependency for staging module
- Remove heat_stack_owner from default admin roles
- Add firewall rule to fix connectivity between guest nodes
- Have the mongodb module manage the mongodb repo
- Update libvirt type parameter for nova config
- Update database connection parameters for keystone endpoint config

##2015-01-14 - Release 5.0.1
###Summary

This is a bugfix release to synchronize the mongodb dependency between
the metadata.json and the Puppetfile.

####Bugfixes
Update mongodb dependency in Puppetfile to 0.10.0

##2015-01-13 - Release 5.0.0
###Summary

This release is the first stable release for Juno.

####Backwards-incompatible Changes:
- Update release default version to Juno
- Update references to old OpenStack versions

####Features
- Add Juno repositories
- Allow user to configure glance API servers not on the controller
- Allow user to configure alternate database users
- Allow user to configure neutron_plugins via parameterization
- Add support for multiple rabbitmq hosts
- Allow user to configure ceilometer servers not on the controller
- Add libvirt migration support
- Use epel module for epel repo management
- Add region parameter for glance

####Bugfixes and changes to the examples
- Update rabbitmq profile to avoid using nova::rabbitmq
- Make controller role compatible with swift deployment
- Use CentOS 7 vm as default example
- Change memory requirements in example vagrant nodes
- Use Ubuntu vm for example puppet node
