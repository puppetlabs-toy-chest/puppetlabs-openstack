class openstack::profile::firewall {
  class { '::openstack::profile::firewall::pre': }
  class { '::openstack::profile::firewall::puppet': }
  class { '::openstack::profile::firewall::post': }

  # fix side effect of CVE-2014-8160 patch:
  #   after applying a kernel upgrade, netfilter default behavior changed,
  #   without this change, guest instacnes running on node with gre tunnel
  #   may have no network access, we need to load an extra kernel module
  #   `nf_conntrack_proto_gre` explicitly to resolve this issue.
  #
  # references:
  #   http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=db29a9508a9246e77087c5531e45b2c88ec6988b
  #   http://www.spinics.net/lists/netfilter-devel/msg33430.html
  #   https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-8160

  if (($::openstack::config::neutron_tunneling == true) and
    (member($::openstack::config::neutron_tenant_network_type, ['gre']))) {
    ::kmod::load { 'nf_conntrack_proto_gre': }
  }
}
