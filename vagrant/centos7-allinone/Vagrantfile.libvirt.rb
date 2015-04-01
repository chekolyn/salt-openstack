# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #config.vm.box = "puppetlabs-centos-7.0-64-nocm"
  config.vm.box = "uvsmtid/centos-7.0-minimal"

    config.vm.provider "libvirt" do |v|
      v.memory = 4096
      v.cpus = 2
      v.video_type = "vga"

  # Configure dhcp on eth0 on reboots:
  config.vm.provision "file", source: "configs/ifcfg-eth0", destination: "/tmp/ifcfg-eth0"
  config.vm.provision "shell", inline: "cp /tmp/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0",
    run: "always"

  # Centos7 Disable Firewall
  config.vm.provision "shell", inline: "systemctl disable firewalld",
    run: "always"
  config.vm.provision "shell", inline: "systemctl stop firewalld",
    run: "always"
  end

  # Testing for nugrant local file:
  unless File.exist?(File.expand_path("~/.vagrantuser"))
    puts "**** PLEASE install and configure the vagrant nugrant plugin *****"
    puts "**** looking for %s *****" % [ File.expand_path("~/.vagrantuser") ]
  else
    puts "**** NUGRANT home file settings found *****"
    puts "**** nugrant home_file: %s ****" % [ File.expand_path("~/.vagrantuser") ]
  end

   # Options for libvirt vagrant provider.
  config.vm.provider :libvirt do |libvirt|

    # NOTE: Using Vagrant nugrant plugin to abstract the hipervisor settings
    # please read to make your local changes: https://github.com/maoueh/nugrant

    # A hypervisor name to access. Different drivers can be specified, but
    # this version of provider creates KVM machines only. Some examples of
    # drivers are kvm (qemu hardware accelerated), qemu (qemu emulated),
    # xen (Xen hypervisor), lxc (Linux Containers),
    # esx (VMware ESX), vmwarews (VMware Workstation) and more. Refer to
    # documentation for available drivers (http://libvirt.org/drivers.html).

    if config.user.libvirt.has_key?(:driver)
      libvirt.driver = config.user.libvirt.driver
    else
      libvirt.driver = "kvm"
    end

    # IMPORTANT support netsted virtualization:
    if config.user.libvirt.has_key?(:nested)
      libvirt.nested = config.user.libvirt.nested
    else
      libvirt.nested = "True"
    end

    # CPU Mode What cpu mode to use for nested virtualization. Defaults to 'host-model' if not set.
    if config.user.libvirt.has_key?(:cpu_mode)
      libvirt.cpu_mode = config.user.libvirt.cpu_mode
    end

    # The name of the server, where libvirtd is running.
    if config.user.libvirt.has_key?(:host)
      libvirt.host = config.user.libvirt.host
    end

    # Localhost change uri:
    # Will override most other settings
    if config.user.libvirt.has_key?(:uri)
      libvirt.uri = config.user.libvirt.uri
    else
      libvirt.uri = 'qemu+unix:///system'
    end

    # If use ssh tunnel to connect to Libvirt.
    if config.user.libvirt.has_key?(:connect_via_ssh)
      libvirt.connect_via_ssh = config.user.libvirt.connect_via_ssh
    else
      libvirt.connect_via_ssh = false
    end

    # The username and password to access Libvirt. Password is not used when
    # connecting via ssh.
    if config.user.libvirt.has_key?(:username)
      libvirt.username = config.user.libvirt.username
    end
    if config.user.libvirt.has_key?(:password)
      libvirt.username = config.user.libvirt.password
    end

    # Libvirt storage pool name, where box image and instance snapshots will
    # be stored.
    if config.user.libvirt.has_key?(:storage_pool_name)
      libvirt.storage_pool_name = config.user.libvirt.storage_pool_name
    else
      libvirt.storage_pool_name = "default"
    end

    # Set a prefix for the machines that's different than the project dir name.
    if config.user.libvirt.has_key?(:default_prefix)
      libvirt.default_prefix = config.user.libvirt.default_prefix
    end

  end

  config.vm.define "master" do |node|

    node.vm.hostname = "master"

    # Openstack Network for Admin/Public/Mgmt
    node.vm.network :private_network, type: "static", ip: "192.168.33.10",
      libvirt__network_name: "salt-os-public",
      libvirt__netmask: "255.255.255.0",
      libvirt__dhcp_enabled: true

    # Openstack Flat Network for openstack
    # no dhcp needed here from vagrant, dhcp via Openstack
    # the ip info here is a dummy config so Vagrant doesn't complain.
    node.vm.network :private_network, ip: "192.168.36.10",
      libvirt__network_name: "salt-os-flat",
      libvirt__netmask: "255.255.255.0",
      libvirt__dhcp_enabled: false,
      auto_config: false

    # Configure SALT info from host gitrepo:
    node.vm.synced_folder "../../file_root/", "/srv/salt", type: "rsync"
    node.vm.synced_folder "pillar_root/", "/srv/pillar", type: "rsync"


    # Fix vagrant libvirt dhcp network issue:
    #node.vm.provision "shell", inline: "ip addr flush eth1 && ifup eth1"

    # salt-master provisioning
    node.vm.provision :salt do |salt|
      salt.install_master = true
      salt.always_install = true
      salt.master_config = "configs/master"
      salt.run_highstate = false
      salt.master_key = 'keys/master.pem'
      salt.master_pub = 'keys/master.pub'

      salt.minion_config = "configs/minion"
      salt.minion_key = 'keys/master.pem'
      salt.minion_pub = 'keys/master.pub'

      salt.seed_master = {
        'master' => 'keys/master.pub',
        'allinone' => 'keys/allinone.pub'
      }
    end
  end

  ## ALLINONE ##
  config.vm.define "allinone" do |node|
    node.vm.hostname = "allinone"

    # Openstack Network for Admin/Public/Mgmt
    node.vm.network :private_network, ip: "192.168.33.21",
      libvirt__network_name: "salt-os-public"

    # Openstack Flat Network for openstack
    # no dhcp needed here from vagrant, dhcp via Openstack
    # the ip info here is a dummy config so Vagrant doesn't complain.
    node.vm.network :private_network, ip: "192.168.36.21",
      libvirt__network_name: "salt-os-flat",
      libvirt__netmask: "255.255.255.0",
      libvirt__dhcp_enabled: false,
      auto_config: false


    # Configure minion_id identifier if using a salted image:
    #node.vm.provision "shell", inline: "echo 'control01' > /etc/salt/minion_id"

    # Fix vagrant libvirt dhcp network issue:
    #node.vm.provision "shell", inline: "ip addr flush eth1 && ifup eth1"
    #node.vm.provision "shell", inline: "ip addr flush eth2"

    # salt-minion provisioning
    node.vm.provision :salt do |salt|
      salt.minion_config = "configs/minion"
      salt.minion_key = 'keys/allinone.pem'
      salt.minion_pub = 'keys/allinone.pub'
      salt.run_highstate = false
    end
  end

end
