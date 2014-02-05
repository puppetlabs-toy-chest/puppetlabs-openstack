# The profile for installing the Swift Proxy
class havana::profile::swift::proxy {
  $api_device = hiera('havana::network::api::device')
  $management_device = hiera('havana::network::management::device')
  $data_device = hiera('havana::network::data::device')
  $external_device = hiera('havana::network::external::device')

  $api_address = getvar("ipaddress_${api_device}")
  $management_address = getvar("ipaddress_${management_device}")
  $data_address = getvar("ipaddress_${data_device}")
  $external_address = getvar("ipaddress_${external_device}")

  $controller_management_address =
    hiera('havana::controller::address::management')
  $controller_api_address = hiera('havana::controller::address::api')

  $storage_management_address = hiera('havana::storage::address::management')
  $storage_api_address = hiera('havana::storage::address::api')

  if $management_address != $controller_management_address {
    fail("Swift Proxy setup failed. The inferred location the
    Swift Proxy the havana::network::management::device hiera value is
    ${management_address}. The explicit address
    from havana::controller::address::management is
    ${controller_management_address}. Please correct this difference.")
  }

  if $api_address != $controller_api_address {
    fail("Swift Proxy setup failed. The inferred location the
    Swift Proxy the havana::network::api::device hiera value is
    ${api_address}. The explicit address
    from havana::controller::address::api is ${controller_api_address}. Please
    correct this difference.")
  }

  firewall { '08080 - Swift Proxy':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8080',
  }

  class { 'swift::keystone::auth':
    password         => hiera('havana::swift::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('havana::region'),
  }

  class { '::swift':
    swift_hash_suffix => hiera('havana::swift::hash_suffix'),
  }

  # sets up the proxy service
  class { '::swift::proxy':
    proxy_local_net_ip => $api_address,
    pipeline           => ['catch_errors', 'healthcheck', 'cache',
                           'ratelimit',    'swift3',
                           'authtoken',    'keystone',    'proxy-server'],
    workers            => 1,
    require            => Class['::swift::ringbuilder'],
  }

  ### BEGIN Middleware Configuration (declared in pipeline for proxy)
  class { ['::swift::proxy::catch_errors',
           '::swift::proxy::healthcheck', ]: }

  class { '::swift::proxy::cache':
    memcache_servers => [ $controller_management_address, ]
  }

  class { ['::swift::proxy::ratelimit',
           '::swift::proxy::swift3', ]: }

  class { '::swift::proxy::authtoken':
    admin_password => hiera('havana::swift::password'),
    auth_host      => $controller_management_address,
  }

  class { '::swift::proxy::keystone': }

  ### END Middleware Configuration

  # collect all of the resources that are needed to balance the ring
  Ring_object_device <<| |>>
  Ring_container_device <<| |>>
  Ring_account_device <<| |>>

  class { 'swift::ringbuilder':
    part_power     => 18,
    replicas       => 3,
    min_part_hours => 1,
    require        => Class['::swift'],
  }

  class { 'swift::ringserver':
    local_net_ip => $controller_management_address,
  }

}
