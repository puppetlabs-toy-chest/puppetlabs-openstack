require "ipaddr"

module Puppet::Parser::Functions

  newfunction(:ip_for_network, :type => :rvalue, :doc => <<-EOS
Returns an ip address for the given network in cidr notation

ip_for_network("127.0.0.0/24") => 127.0.0.1
    EOS
  ) do |args| 
    addresses_in_range = [] 

    range = IPAddr.new(args[0])
    facts = compiler.node.facts.values
    ip_addresses = facts.select { |key, value| key.match /^ipaddress/ }

    ip_addresses.each do |pair|
      key = pair[0]
      string_address = pair[1]
      ip_address = IPAddr.new(string_address)
      if range.include?(ip_address)
        addresses_in_range.push(string_address)
      end
    end

    # TODO don't be a dork dork with the return
    # handle multiple values!
    return addresses_in_range.first
  end
end
