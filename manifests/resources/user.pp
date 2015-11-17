define openstack::resources::user (
  $password,
  $tenant,
  $email,
  $admin   = false,
  $enabled = true,
  $domain = 'Default',
) {
  keystone_user { $name:
    ensure   => present,
    enabled  => $enabled,
    password => $password,
    email    => $email,
    domain   => $domain,
  }

  if $admin == true {
    keystone_user_role { "${name}@${tenant}":
      ensure         => present,
      roles          => ['_member_', 'admin', 'heat_stack_owner', 'SwiftOperator'],
      user_domain    => $domain,
      project_domain => $domain,
    }
  } else {
    keystone_user_role { "${name}@${tenant}":
      ensure => present,
      roles  => ['_member_', 'heat_stack_owner', 'SwiftOperator'],
      user_domain    => $domain,
      project_domain => $domain,
    }
  }
}
