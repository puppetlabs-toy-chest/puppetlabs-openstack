require 'spec_helper_acceptance'

describe 'openstack::role::controller' do
  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS
      class { 'openstack':
        use_hiera                     => false,
        ceilometer_password           => 'whi-truz',
        ceilometer_meteringsecret     => 'ceilometersecretkey',
        controller_address_api        => $::ipaddress_eth0,
        controller_address_management => $::ipaddress_eth0,
        heat_password                 => 'zap-bang',
        keystone_admin_password       => 'fyby-tet',
        keystone_tenants              => {
          test  => {
            description => 'Test tenant',
          },
          test2 => {
            description => 'Test tenant',
          },
        },
        keystone_users                => {
          test  => {
            password => 'abc123',
            tenant   => 'test',
            email    => 'test@example.com',
            admin    => true,
          },
          demo  => {
            password => 'abc123',
            tenant   => 'test',
            email    => 'demo@example.com',
            admin    => false,
          },
          demo2 => {
            password => 'abc123',
            tenant   => 'test2',
            email    => 'demo@example.com',
            admin    => false,
          },
        },
        mysql_service_password        => 'fuva-wax',
        network_api                   => "${::network_eth0}/24",
        network_data                  => "${::network_eth0}/24",
        network_management            => "${::network_eth0}/24",
        neutron_password              => 'whi-rtuz',
        nova_password                 => 'quuk-paj',
        rabbitmq_password             => 'pose-vix',
        region                        => 'openstack',
        swift_password                => 'dexc-flo',
        swift_hash_suffix             => 'pop-bang',
      }
      class { 'openstack::role::controller': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
