class openstack::resources::connectors {

  $management_address = $::openstack::config::controller_address_management
  $password = $::openstack::config::mysql_service_password

  $cinder   = "mysql://cinder:${password}@${management_address}/cinder"
  $glance   = "mysql://glance:${password}@${management_address}/glance"
  $heat     = "mysql://heat:${password}@${management_address}/heat"
  $ironic   = "mysql://ironic:${password}@${management_address}/ironic"
  $keystone = "mysql://keystone:${password}@${management_address}/keystone"
  $neutron  = "mysql://neutron:${password}@${management_address}/neutron"
  $nova     = "mysql://nova:${password}@${management_address}/nova"
  $novaapi  = "mysql://novaapi:${password}@${management_address}/novaapi"
  $sahara   = "mysql://sahara:${password}@${management_address}/sahara"
  $trove    = "mysql://trove:${password}@${management_address}/trove"
}
