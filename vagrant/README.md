## Setup Vagrant Enviroment

### Install Vagrant
http://docs.vagrantup.com/v2/installation/

### Vagrant Hypervisor Options

Vagrant files will primarly target libvirt.

### Install Vagrant Plugins
The only plugins dependencies for our setup will be:  vagrant-libvirt and nugrat.
Nugrat provides some flexibility for libvirt variables in the Vagrantfiles. 

	vagrant plugin install vagrant-libvirt
	vagrant plugin install nugrant
	
### Install Libvirtd/KVM
https://help.ubuntu.com/community/KVM/Installation 
Protip: Make sure your standard username can create VMs directly to Libvirt don't use root
see Ubuntu documentation link: https://help.ubuntu.com/community/KVM/Installation	
	
### Configure your nugrat settings
The nugrant plugin will look for /home/[username]/.vagrantuser

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
  
  
Remote server config example 

	libvirt:
	  driver: "kvm"
	  memory: "4096"
	  cpu:    "4"
	  nested: "True"
	  cpu_mode: "host-model"
	  host: "remotehost.example.com"
	  username: "username"
	  connect_via_ssh: true
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
	
### Bugs
The "uvsmtid/centos-7.0-minimal" box has Networkmanager by default. 
salt-openstack will disable and remove Networkmanager sometimes this has the effect that the vms get disconnected from the Vagrant Managment network (vagrant-libvirt) on eth0.
There is a "configs/ifcfg-eth0" file that will enable dhcp on eth0, you might need to do this to get a dhcp lease in the console:

	ifdown eth0 && ifup eth0

A bootstrap script that addresses this might be helpful in the future. 

