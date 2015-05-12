require "ipaddr"

module Puppet::Parser::Functions

  newfunction(:ip_for_network, :type => :rvalue, :doc => <<-EOS
Returns an ip address for the given network in cidr notation

ip_for_network("127.0.0.0/24") => 127.0.0.1
    EOS
  ) do |args|
    addresses_in_range = []
    ip_addresses = []
    interfaces = []

    range = IPAddr.new(args[0])
    interfaces = lookupvar('interfaces').split(",")
    interfaces.each do |i|
      ip = lookupvar("ipaddress_#{i}")
      unless ip.nil?
        ip_addresses.push(ip)
      end
    end

    ip_addresses.each do |string_address|
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
