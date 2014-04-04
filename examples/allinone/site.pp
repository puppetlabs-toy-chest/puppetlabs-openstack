node 'puppet' {
  include ::ntp
}

node 'allinone.localdomain' {
  include ::openstack::role::allinone
}
