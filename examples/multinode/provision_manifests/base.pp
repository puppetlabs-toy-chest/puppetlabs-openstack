# Point the node's hostname to 127.0.0.1
#
# The vagrant hostmanager points the node's hostname to its public IP in
# /etc/hosts. This causes problems for the rabbitmq processes running
# on localhost that use a number of different ports and use the host's
# name to communicate with the cluster.
#
# Ideally we would configure the firewall to open the rabbitmq ports
# and allow access to the rabbitmq nodes, but we can't restrict the
# clustered node ports with early version of the rabbitmq module and
# therefore we can't open those ports. Instead we just ensure that
# requests on localhost use the localhost network. We will replace
# this with firewall rules in the rabbitmq profile when all the
# stackforge modules have upgraded to puppetlabs-rabbitmq >=5.x
#
host { 'localhost':
  ensure => present,
  name   => $::hostname,
  ip     => '127.0.0.1',
}
