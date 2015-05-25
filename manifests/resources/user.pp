define openstack::resources::user (
  $password,
  $tenant,
  $email,
  $admin   = false,
  $enabled = true,
) {
  keystone_user { $name:
    ensure   => present,
    enabled  => $enabled,
    password => $password,
    tenant   => $tenant,
    email    => $email,
  }

  if $admin == true {
    keystone_user_role { "${name}@${tenant}":
      ensure => present,
      roles  => ['_member_', 'admin'],
    }
  } else {
    keystone_user_role { "${name}@${tenant}":
      ensure => present,
      roles  => ['_member_'],
    }
  }
}
