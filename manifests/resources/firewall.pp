define havana::resources::firewall ( $port ) {
  firewall { "${port} - ${title}":
    proto  => 'tcp',
    state  => ['NEW'],
    action => 'accept',
    port   => $port,
  }
}
