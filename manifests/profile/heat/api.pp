# The profile for installing the heat API
class havana::profile::heat::api {
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
    fail("heat API/Scheduler setup failed. The inferred location the
    heat API the havana::network::management::device hiera value is
    ${management_address}. The explicit address
    from havana::controller::address::management is
    ${controller_management_address}. Please correct this difference.")
  }

  if $api_address != $controller_api_address {
    fail("heat API/Scheduler setup failed. The inferred location the
    heat API the havana::network::api::device hiera value is
    ${api_address}. The explicit address
    from havana::controller::address::api is ${controller_api_address}. Please
    correct this difference.")
  }

  firewall { '08004 - Heat API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8004',
  }

  firewall { '08000 - Heat CFN API':
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => '8000',
  }

  $sql_password = hiera('havana::heat::sql::password')
  $sql_connection =
    "mysql://heat:${sql_password}@${controller_management_address}/heat"

  class { '::heat::db::mysql':
    password      => $sql_password,
    allowed_hosts => hiera('havana::mysql::allowed_hosts'),
  }

  class { '::heat::keystone::auth':
    password         => hiera('havana::heat::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('havana::region'),
  }

  class { '::heat::keystone::auth_cfn': 
    password         => hiera('havana::heat::password'),
    public_address   => $api_address,
    admin_address    => $management_address,
    internal_address => $management_address,
    region           => hiera('havana::region'),
  }

  class { '::heat':
    sql_connection    => $sql_connection,
    rabbit_host       => $controller_management_address,
    rabbit_userid     => hiera('havana::rabbitmq::user'),
    rabbit_password   => hiera('havana::rabbitmq::password'),
    debug             => hiera('havana::cinder::debug'),
    verbose           => hiera('havana::cinder::verbose'),
    keystone_host     => $controller_management_address,
    keystone_password => hiera('havana::heat::password'),
  }

  class { '::heat::api':
    bind_host => $api_address,
  }

  class { '::heat::api_cfn':
    bind_host => $api_address,
  }

  class { '::heat::engine':
    auth_encryption_key => hiera('havana::heat::encryption_key'),
  }
}
