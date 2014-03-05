require "ipaddr"

module Puppet::Parser::Functions

  newfunction(:device_for_network, :type => :rvalue, :doc => <<-EOS
Returns the device for the given network in cidr notation

device_for_network("127.0.0.0/24") => lo0
    EOS
  ) do |args| 
    devices_in_range = [] 

    range = IPAddr.new(args[0])
    facts = compiler.node.facts.values
    ip_addresses = facts.select { |key, value| key.match /^ipaddress_(.*)/ }

    ip_addresses.each do |pair|
      key = pair[0]
      string_address = pair[1]
      ip_address = IPAddr.new(string_address)
      if range.include?(ip_address)
        devices_in_range.push(key.gsub(/^ipaddress_/,""))
      end
    end

    # TODO don't be a dork dork with the return
    # handle multiple values!
    return devices_in_range.first
  end
end
