## Setup Vagrant Enviroment

### Install Vagrant
http://docs.vagrantup.com/v2/installation/


### Vagrant Options

Vagrant files will primarly target libvirt.

### Install Vagrant Plugins
The only plugin dependency for our setup will be nugrat, this is to provide some flexibility for libvirt variables. 

	vagrant plugin install nugrant
	
### Install Libvirtd/KVM
https://help.ubuntu.com/community/KVM/Installation 
Protip: Make sure your standard username can create VMs directly to Libvirt
see Ubuntu documentation link: https://help.ubuntu.com/community/KVM/Installation 	
	
### Configure your nugrat settings
The nugrant plugin will look for /home/[yourusername]/.vagrantuser

Localhost config example

libvirt:
  driver: "kvm"
  memory: "4096"
  cpu:    "4"
  nested: "True"
  cpu_mode: "host-model"
  uri: "qemu+unix:///system"
  host: ""
  username: ""
  password: ""
  connect_via_ssh: False
  storage_pool_name: "default"

Note: if you use **uri** - For advanced usage. Directly specifies what libvirt connection URI vagrant-libvirt should use. Overrides all other connection configuration options.

### Test environment with Vagrant

	cd vagrant/centos7-allinone  && vagrant up
	
Following the instructions at https://github.com/cloudbase/salt-openstack#3-install-openstack 

They would translate to the allinone example like this (you have to do this on the master node)

Login to you master node:

	vagrant ssh master
	
[root@master ~]#

    sudo salt -L 'allinone' saltutil.refresh_pillar                         
    # It will make the OpenStack parameters available on the targeted minion(s).

    sudo salt -L 'allinone' saltutil.sync_all                               
    # It will upload all of the custom dynamic modules to the targeted minion(s). 
    # Custom modules for OpenStack (network create, router create, security group create, etc.) have been defined.

    sudo salt -C 'I@devcluster:devcluster' state.highstate  
    # It will install the OpenStack environment 
    

Alternatively: you can login to the allinone node and run as root:  salt-call state.highstate
	
### Bugs
The "uvsmtid/centos-7.0-minimal" box has Networkmanager by default; salt-openstack will disable and remove network manager sometimes this has the effect that the vms get disconnected from the vagrant-libvirt network on eth0.
There is a configs/ifcfg-eth0 file that will enable dhcp on eth0, you might need to do ifdown eth0 && ifup eth0 to get a dhcp lease in the console.


