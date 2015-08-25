# Multinode

### Description

This is a multinode implementation.

### Test environment with Vagrant

Make sure that the master is up before the the other nodes.
This example has **salt.run_highstate = true** variable on so it will run salt automatically on the allinone node.

	cd vagrant/centos7-multinode  && vagrant up master && vagrant up control01 && vagrant up node01
	
	
Following the instructions at https://github.com/cloudbase/salt-openstack#3-install-openstack 

They would translate to the allinone example like this (you have to do this on the master node)

Login to your master node:

	vagrant ssh master
	
[root@master ~]#

    sudo salt -L 'control01,node01' saltutil.refresh_pillar                         
    # It will make the OpenStack parameters available on the targeted minion(s).

    sudo salt -L 'control01,node01' saltutil.sync_all                               
    # It will upload all of the custom dynamic modules to the targeted minion(s). 
    # Custom modules for OpenStack (network create, router create, security group create, etc.) have been defined.

    sudo salt -L 'control01,node01' state.highstate
    # It will install the OpenStack environment 


### Networks

Network | Subnet | Description
--- | --- | ---
vagrant-libvirt | 192.168.121.0/24 | Default vagrant management network
salt-os-public | 192.168.33.0/24 | Openstack Public/Admin/Mgmt network
salt-os-flat | 192.168.36.0/24 | Openstack Flat Network

### Hosts

|    Hostname   |     IP        | Description                |
| ------------- |:-------------:|:--------------------------:|
| master        | 192.168.33.10 | salt master                |
| control01     | 192.168.33.21 | controller                 |
| node01        | 192.168.33.31 | compute/storage node       |
| node02        | 192.168.33.32 | compute/storage node       |
| node03        | 192.168.33.33 | compute/storage node       |


#### Horizon URL
[http://192.168.33.21/dashboard](http://192.168.33.21/dashboard)