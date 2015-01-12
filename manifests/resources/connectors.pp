class openstack::resources::connectors {

  $management_address = $::openstack::config::controller_address_management
  $password = $::openstack::config::mysql_service_password

  # keystone
  $user_keystone = $::openstack::config::mysql_user_keystone
  $pass_keystone = $::openstack::config::mysql_pass_keystone

  if ! $user_keystone or ! $pass_keystone {
    $keystone   = "mysql://keystone:${password}@${management_address}/keystone"
  } else {
    $keystone   = "mysql://${user_keystone}:${pass_keystone}@${management_address}/keystone"
  }

  # cinder
  $user_cinder  = $::openstack::config::mysql_user_cinder
  $pass_cinder  = $::openstack::config::mysql_pass_cinder

  if ! $user_cinder or ! $pass_cinder {
    $cinder     = "mysql://cinder:${password}@${management_address}/cinder"
  } else {
    $cinder     = "mysql://${user_cinder}:${pass_cinder}@${management_address}/cinder"
  }

  # glance
  $user_glance  = $::openstack::config::mysql_user_glance
  $pass_glance  = $::openstack::config::mysql_pass_glance

  if ! $user_glance or ! $pass_glance {
    $glance     = "mysql://glance:${password}@${management_address}/glance"
  } else {
    $glance     = "mysql://${user_glance}:${pass_glance}@${management_address}/glance"
  }

  # nova
  $user_nova    = $::openstack::config::mysql_user_nova
  $pass_nova    = $::openstack::config::mysql_pass_nova

  if ! $user_nova or ! $pass_nova {
    $nova       = "mysql://nova:${password}@${management_address}/nova"
  } else {
    $nova       = "mysql://${user_nova}:${pass_nova}@${management_address}/nova"
  }

  # neutron
  $user_neutron = $::openstack::config::mysql_user_neutron
  $pass_neutron = $::openstack::config::mysql_pass_neutron

  if ! $user_nova or ! $pass_nova {
    $neutron    = "mysql://neutron:${password}@${management_address}/neutron"
  } else {
    $neutron    = "mysql://${user_neutron}:${pass_neutron}@${management_address}/neutron"
  }

  # heat
  $user_heat    = $::openstack::config::mysql_user_heat
  $pass_heat    = $::openstack::config::mysql_pass_heat

  if ! $user_heat or ! $pass_heat {
    $heat       = "mysql://heat:${password}@${management_address}/heat"
  } else {
    $heat       = "mysql://${user_heat}:${pass_heat}@${management_address}/heat"
  }
}
