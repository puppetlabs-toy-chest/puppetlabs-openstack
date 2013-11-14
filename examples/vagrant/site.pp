node 'puppet' {
  include ::ntp
}

node 'control.localdomain' {
  include ::havana::role::controller
}

node 'storage.localdomain' {
  include ::havana::role::storage
}

node 'network.localdomain' {
  include ::havana::role::network
}

node /compute[0-9]+.localdomain/ {
  include ::havana::role::compute
}

