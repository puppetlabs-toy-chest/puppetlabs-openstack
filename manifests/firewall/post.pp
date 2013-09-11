# post-firewall rules to reject remaining traffic
class grizzly::firewall::post {
  #6    REJECT     all  --  0.0.0.0/0            0.0.0.0/0
  #reject-with icmp-host-prohibited
  firewall { '99999':
    action => 'reject',
    proto  => 'all',
    reject => 'icmp-host-prohibited',
    before => undef,
  }
  #Chain FORWARD (policy ACCEPT)
  #num  target     prot opt source               destination
  #1    REJECT     all  --  0.0.0.0/0            0.0.0.0/0
  # reject-with icmp-host-prohibited

  #Chain OUTPUT (policy ACCEPT)
  #num  target     prot opt source               destination
}
