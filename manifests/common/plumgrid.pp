# Common class used by Plumgrid Neutron Plugin.

class openstack::common::plumgrid {
  # forward all ipv4 traffic
  # this is required for the vms to pass through the gateways public interface
  sysctl::value { 'net.ipv4.ip_forward': value => '1' }

  # ifc_ctl_pp needs to be invoked by root as part of the vif.py when a VM is powered on
  file { "/etc/sudoers.d/ifc_ctl_sudoers":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0440,
    content => "nova ALL=(root) NOPASSWD: /opt/pg/bin/ifc_ctl_pp *\n",
  }

  # Install the nova-api
  nova::generic_service { 'api':
    enabled      => true,
    package_name => $::nova::params::api_package_name,
    service_name => $::nova::params::api_service_name,
  }

  nova_config {
   'neutron/service_metadata_proxy': value => true;
   'neutron/metadata_proxy_shared_secret':
      value => $::openstack::config::neutron_shared_secret;
  }
}
