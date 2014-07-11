A few notes on using Vagrant and VMWare Fusion to test the Havana module:

Five networks need to be setup in VMWare Fusion. The default net for
Vagrant, and the four OpenStack networks.

*  eth0: Share with my Mac
*  eth1: 192.168.11.0/24 (netmask 255.255.255.0)
*  eth2: 192.168.22.0/24 (netmask 255.255.255.0)
*  eth3: 172.16.33.0/24 (netmask 255.255.255.0)
*  eth4: 172.16.44.0/24 (netmask 255.255.255.0)

Getting these networks up and running with Vagrant and VMWare Fusion can
be a bit tricky. The networks will be set up automatically by Vagrant,
but you should take some time to set "allow promiscuous" in the VMWare
settings. The 192.* networks should be visible to your computer, the
172.* networks shouldn't (the difference between public and private).

You will likely need to reboot your computer to get the networks to behave
properly. Sorry about that.

The IP address reservation is

* 0.0.0.1  : Host OS
* 0.0.0.2  : VMWare Router
* 0.0.0.3  : Puppet Master
* 0.0.0.4  : OS Controller
* 0.0.0.5  : OS Storage
* 0.0.0.6  : OS Networking
* 0.0.0.7  : OS Compute
* 0.0.0.11 : Tempest

Vagrant needs the hostmanager plugin installed:

```
vagrant plugin install vagrant-hostmanager
```

The Vagrantfile will automatically download a prepared CentOS box for you.

You need to have R10K installed. You can use the one provided by the rubygem.

```
ruby gem install R10K
```

Using R10K, module dependencies are automatically downloaded and the root of the module
directory is attached to the virtual machines. This can help with module development.
Any changes you make to the module will appear on the Puppet master. Additionally,
using the Python script in the ../../tools directory you can apply pending patches
from Stackforge to the dependencies, giving you an opportunity to test out changes
before they're merged. To try it out use the command:

```
python ../../tools/review_checkout.py -u <gerrit_username> -c <review_id>
```

The <review_id> refers to the URL for OpenStack Gerrit. So, if your review was located at 
https://review.openstack.org/#/c/81989/ the `<review_id>` would be 81989.

Running the script will produce output that is itself a script. You can apply the patch by
piping it to a shell.

```
python ../../tools/review_checkout.py -u <gerrit_username> -c <review_id> | sh
```

You can log into your console through the API network and the
[Horizon interface](http://192.168.11.4).
