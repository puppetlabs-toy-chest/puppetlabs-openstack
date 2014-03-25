# Profile to install the horizon web service
class havana::profile::horizon {
  class { '::horizon':
    fqdn            => [ '127.0.0.1', hiera('havana::controller::address::api'), $::fqdn ],
    secret_key      => hiera('havana::horizon::secret_key'),
    cache_server_ip => hiera('havana::controller::address::management'),

  }


  havana::resources::firewall { 'Apache (Horizon)': port => '80' }
  havana::resources::firewall { 'Apache SSL (Horizon)': port => '443' }

  if $::selinux and str2bool($::selinux) != false {
    selboolean{'httpd_can_network_connect':
      value      => on,
      persistent => true,
    }
  }

}
