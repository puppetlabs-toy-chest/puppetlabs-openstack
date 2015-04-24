node 'puppet' {
  include ::ntp
}

node /allinone/ {
  include ::openstack::role::allinone
}
