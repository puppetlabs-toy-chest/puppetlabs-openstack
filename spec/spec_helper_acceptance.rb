require 'beaker-rspec'
require 'pry'

hosts.each do |host|
  # Install Ruby
  install_package host, 'ruby'
  # Install Puppet
  on host, "ruby --version | cut -f2 -d ' ' | cut -f1 -d 'p'" do |version|
    version = version.stdout.strip
    if Gem::Version.new(version) < Gem::Version.new('1.9')
      install_package host, 'rubygems'
    end
  end
  on host, 'gem install puppet --no-ri --no-rdoc'
  on host, "mkdir -p #{host['distmoduledir']}"
  # Install git (to fetch modules from github)
  install_package host, 'git'
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'openstack')
    hosts.each do |host|
      ['cinder', 'glance', 'neutron', 'nova', 'openstacklib'].each do |component|
        on host, "git clone https://github.com/stackforge/puppet-#{component}.git #{host['distmoduledir']}/#{component} || true"
      end
      ['rabbitmq'].each do |component|
        on host, "git clone https://github.com/puppetlabs/puppetlabs-#{component}.git #{host['distmoduledir']}/#{component} || true"
      end
      on host, puppet('module','install','puppetlabs-ceilometer'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-firewall'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-heat'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-horizon'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-keystone'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-mongodb'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-ntp'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-swift'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-vswitch'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','nanliu-staging'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','saz-memcached'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
