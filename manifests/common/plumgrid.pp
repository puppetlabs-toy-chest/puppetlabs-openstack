class openstack::common::plumgrid {
  $pg_package_ensure       = 'latest'
  $pg_connection           = $::openstack::resources::connectors::neutron
  $pg_director_server      = $::openstack::config::pg_director_server
  $pg_director_server_port = '443'
  $pg_username             = $::openstack::config::pg_username
  $pg_password             = $::openstack::config::pg_password
  $pg_servertimeout        = '70'
  $pg_enable_metadata_agent = $::openstack::config::pg_enable_metadata_agent
  $pg_fabric_eth           = $::openstack::config::pg_fabric_eth

  ### PLUMgrid Controller Node Configuration
  if $::openstack::config::pg_controller { 
    class { '::neutron::plugins::plumgrid':
     package_ensure          => $pg_package_ensure,
     connection              => $pg_connection,
     pg_director_server      => $pg_director_server,
     pg_director_server_port => $pg_director_server_port,
     pg_username             => $pg_username,
     pg_password             => $pg_password,
     pg_servertimeout        => $pg_servertimeout,
     enable_metadata_agent   => $pg_enable_metadata_agent,
     fabric_eth              => $pg_fabric_eth,
    }

    nova_config { 'DEFAULT/scheduler_driver': value => 'nova.scheduler.filter_scheduler.FilterScheduler' }
    nova_config { 'DEFAULT/libvirt_vif_type': value => 'ethernet'}
    nova_config { 'DEFAULT/libvirt_cpu_mode': value => 'none'}
  }

  ### PLUMgrid Compute Node Configuration
  if $::openstack::config::pg_compute { 
    include nova::params

    class { 'nova::api':
      admin_password    => $nova_user_password,
      enabled           => true,
      auth_host         => $controller_node_address,
      admin_tenant_name => $nova_admin_tenant_name,
    }

    nova_config { 'DEFAULT/scheduler_driver': value => 'nova.scheduler.filter_scheduler.FilterScheduler' }
    nova_config { 'DEFAULT/libvirt_vif_type': value => 'ethernet'}
    nova_config { 'DEFAULT/libvirt_cpu_mode': value => 'none'}

    # forward all ipv4 traffic
    # this is required for the vms to pass through the gateways
    # public interface
    Exec {
      path => $::path
    }

    sysctl::value { 'net.ipv4.ip_forward':
      value => '1'
    }

    # network.filters should only be included in the nova-network node package
    # Reference: https://wiki.openstack.org/wiki/Packager/Rootwrap
    nova::generic_service { 'network.filters':
      package_name   => $::nova::params::network_package_name,
      service_name   => $::nova::params::network_service_name,
    }

    class { 'libvirt':
      qemu_config => {
              cgroup_device_acl => { value => ["/dev/null","/dev/full","/dev/zero",
              "/dev/random","/dev/urandom","/dev/ptmx",
              "/dev/kvm","/dev/kqemu",
              "/dev/rtc","/dev/hpet","/dev/net/tun"] },
               clear_emulator_capabilities => { value => 0 },
               user => { value => "root" },
        },
    }

    file { "/etc/sudoers.d/ifc_ctl_sudoers":
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => 0440,
      content => "nova ALL=(root) NOPASSWD: /opt/pg/bin/ifc_ctl_pp *\n",
      require => [ Package[$::nova::params::compute_package_name], ],
    }
  }
}
