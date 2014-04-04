define openstack::resources::firewall ( $port ) {
  # The firewall module can not handle managed rules with a leading 9 properly
  if $port =~ /9[0-9]+/ {
    firewall { "8${port} - ${title}":
      proto  => 'tcp',
      state  => ['NEW'],
      action => 'accept',
      port   => $port,
      before => Firewall['8999 - Accept all management network traffic'],
    }
  } else {
    firewall { "${port} - ${title}":
      proto  => 'tcp',
      state  => ['NEW'],
      action => 'accept',
      port   => $port,
      before => Firewall['8999 - Accept all management network traffic'],
    }
  }
}
