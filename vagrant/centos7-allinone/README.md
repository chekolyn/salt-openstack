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
salt-os-public | 192.168.34.0/24 | Openstack Public/Admin/Mgmt network
salt-os-flat | 192.168.37.0/24 and 169.254.169.0/24 | Openstack Flat Network and metadata subnet

### Metadata Subnet notes:

We need to modify the Libvirt network: **salt-os-flat** in order to make the metadata subnet **169.254.169.0/24** and the salt-os-flat subnet: 192.168.37.0/24 **co-exist**

We need to edit the salt-os-flat network

	virsh net-edit salt-os-flat

and add:
```xml
<ip address='169.254.169.1' netmask='255.255.255.0'>
</ip>
```

From ( be careful with the uuid and the bridge name it could be different in your environment):
```xml
<network ipv6='yes'>
<name>salt-os-flat</name>
<uuid>d99663dc-78df-4e56-9746-7cfbb4a4054a</uuid>
<forward mode='nat'/>
<bridge name='virbr3' stp='on' delay='0'/>
<mac address='52:54:00:f5:de:d8'/>
<ip address='192.168.37.1' netmask='255.255.255.0'>
</ip>
</network>
```

To:

```xml
<network ipv6='yes'>
  <name>salt-os-flat</name>
  <uuid>d99663dc-78df-4e56-9746-7cfbb4a4054a</uuid>
  <forward mode='nat'/>
  <bridge name='virbr3' stp='on' delay='0'/>
  <mac address='52:54:00:f5:de:d8'/>
  <ip address='192.168.37.1' netmask='255.255.255.0'>
  </ip>
  <ip address='169.254.169.1' netmask='255.255.255.0'>
  </ip>
</network>
```

We need to recreate the salt-os-flat network for the changes to take effect; unfortunately if there are any VMs atttached they will get disconnected; stopping and staring the VMs will re-add them to the network.

	virsh net-destroy salt-os-flat
	virsh net-start salt-os-flat


### Hosts

|    Hostname   |     IP        | Description   |
| ------------- |:-------------:|:-------------:|
| master        | 192.168.34.10 | salt master   |
| allinone      | 192.168.34.21 | allinone node |


#### Horizon URL
[http://192.168.34.21/dashboard](http://192.168.34.21/dashboard)
