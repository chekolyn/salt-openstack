# Allinone

### Description

This is an allinone implementation. All roles will be applied to the allinone node.

### Test environment with Vagrant

Make sure that the master is up before the allinone node.
This example has **salt.run_highstate = true** variable on so it will run salt automatically on the allinone node.

	cd vagrant/centos7-allinone  && vagrant up master && vagrant up allinone
	
### Networks

Network | Subnet | Description
--- | --- | ---
vagrant-libvirt | 192.168.121.0/24 | Default vagrant management network
salt-os-public | 192.168.33.0/24 | Openstack Public/Admin/Mgmt network
salt-os-flat | 192.168.36.0/24 | Openstack Flat Network

### Hosts

|    Hostname   |     IP        | Description   |
| ------------- |:-------------:|:-------------:|
| master        | 192.168.33.10 | salt master   |
| allinone      | 192.168.33.21 | allinone node |


#### Horizon URL
[http://192.168.33.21/dashboard](http://192.168.33.21/dashboard)