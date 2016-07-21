define openstack::resources::tenant (
  $description,
  $enabled = true,
  $domain = 'Default',
) {
  keystone_tenant { $name:
    ensure      => present,
    description => $description,
    enabled     => $enabled,
    domain      => $domain,
  }
}
