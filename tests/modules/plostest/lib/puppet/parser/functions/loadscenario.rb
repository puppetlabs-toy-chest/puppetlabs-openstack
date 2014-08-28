module Puppet::Parser::Functions
  newfunction(:loadscenario, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Load a YAML scenario file.
    For example:

        $myhash = loadscenario('allinone')
    ENDHEREDOC

    # parse the argument list
    unless args.length == 1
      raise Puppet::ParseError, ("loadscenario(): wrong number of arguments (#{args.length}; must be 1)")
    end
    scenario = args[0]

    # load information about the module
    test_module = Puppet::Module.find('plostest')
    path = test_module.path
    data_file = File.join(path,'data',"#{scenario}.yaml")

    # load and return the yaml
    YAML.load_file(data_file)
  end
end
