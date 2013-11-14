A few notes on using Vagrant and VMWare Fusion to test the Havana module:

Five networks need to be setup in VMWare Fusion. The default net for
Vagrant, and the four OpenStack networks.

*  eth0: Share with my Mac
*  eth1: 192.168.11.0/24 (netmask 255.255.255.0)
*  eth2: 192.168.22.0/24 (netmask 255.255.255.0)
*  eth3: 172.16.33.0/24 (netmask 255.255.255.0)
*  eth4: 172.16.44.0/24 (netmask 255.255.255.0)

The IP address reservation is

* 0.0.0.1 : Host OS
* 0.0.0.2 : VMWare Router
* 0.0.0.3 : Puppet Master
* 0.0.0.4 : OS Controller
* 0.0.0.5 : OS Storage
* 0.0.0.6 : OS Networking
* 0.0.0.7 : OS Compute

Vagrant needs the hostfile plugin installed:

```
vagrant plugin install vagrant-hostfile
```

It's assumed that you've installed a Red Hat family Vagrant
box, and have installed the latest version of Puppet from
the [Puppet Labs Repository](http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html).

Run the scripts in sequential order. Once the final script has run,
you can log into your console through the API network and the
[Horizon interface](http://192.168.11.4).
