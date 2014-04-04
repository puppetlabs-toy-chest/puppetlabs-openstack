# A convenience method to set up a router between
# a private subnet and the public network. The
# $title of the resource is 'tenant:subnet',
# where tenant is the name of the tenant to assign
# the router to and subnet is the name of the
# subnet to connect the router to.

define openstack::setup::router {
  $valarray = split($title, ':')
  $tenant = $valarray[0]
  $subnet = $valarray[1]

  neutron_router { $tenant:
    tenant_name          => $tenant,
    gateway_network_name => 'public',
    require              => [Neutron_network['public'], Neutron_subnet["${subnet}"]]
  } ->

  neutron_router_interface  { $title:
    ensure => present
  }
}
