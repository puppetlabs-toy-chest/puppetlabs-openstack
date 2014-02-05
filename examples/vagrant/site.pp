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

node 'compute.localdomain' {
  include ::havana::role::compute
}

node 'swiftstore1.localdomain' {
  class { '::havana::role::swiftstorage':
    zone => '1'
  }
}

node 'swiftstore2.localdomain' {
  class { '::havana::role::swiftstorage':
    zone => '2'
  }
}

node 'swiftstore3.localdomain' {
  class { '::havana::role::swiftstorage':
    zone => '3'
  }
}
