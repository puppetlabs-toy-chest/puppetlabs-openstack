node 'puppet' {
  include ::ntp
}

node 'control.localdomain' {
  include ::grizzly::role::controller
}

node 'storage.localdomain' {
  include ::grizzly::role::storage
}

node 'network.localdomain' {
  include ::grizzly::role::network
}

node /compute[0-9]+.localdomain/ {
  include ::grizzly::role::compute
}

