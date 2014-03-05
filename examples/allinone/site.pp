node 'puppet' {
  include ::ntp
}

node 'allinone.localdomain' {
  include ::havana::role::allinone
}
