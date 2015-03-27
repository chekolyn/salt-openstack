# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "puppetlabs-centos-7.0-64-nocm"
  config.vm.box_url = "https://vagrantcloud.com/puppetlabs/boxes/centos-7.0-64-nocm/versions/1.0.1/providers/virtualbox.box"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2

  # Centos7 Disable Firewall in all VMs
  config.vm.provision "shell", inline: "systemctl disable firewalld",
    run: "always"
  config.vm.provision "shell", inline: "systemctl stop firewalld",
    run: "always"
  end

  config.vm.define "master" do |node|
    node.vm.hostname = "master"
    node.vm.network :private_network, ip: "192.168.33.10"

    node.vm.synced_folder "../../file_root/", "/srv/salt"
    node.vm.synced_folder "pillar_root/", "/srv/pillar"

    # Configure minion_id identifier
    # node.vm.provision "shell", inline: "echo 'master' > /etc/salt/minion_id"

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
        'control01' => 'keys/control01.pub',
        'node01' => 'keys/node01.pub',
        'node02' => 'keys/node02.pub',
        'node03' => 'keys/node03.pub'
      }
    end
  end

  ## CONTROLLER ##
  config.vm.define "control01" do |node|
    node.vm.hostname = "control01"

    # Network for Admin/Public/Mgmt
    node.vm.network :private_network, ip: "192.168.33.21"

    # Flat Network
    node.vm.network :private_network, ip: "192.168.36.0", auto_config: false

    # Configure promisc mode
    node.vm.provider "virtualbox" do |v|
      # Configure promisc mode
      v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end

    # Configure minion_id identifier if using a salted image:
    #node.vm.provision "shell", inline: "echo 'control01' > /etc/salt/minion_id"

    # salt-minion provisioning
    node.vm.provision :salt do |salt|
      salt.minion_config = "configs/minion"
      salt.minion_key = 'keys/control01.pem'
      salt.minion_pub = 'keys/control01.pub'
    end
  end

  ## NODES ##
  config.vm.define "node01" do |node|
    node.vm.hostname = "node01"

    # Network for Admin/Public/Mgmt
    node.vm.network :private_network, ip: "192.168.33.31"

    # Flat Network
    node.vm.network :private_network, ip: "192.168.36.0", auto_config: false

    # Configure promisc mode
    node.vm.provider "virtualbox" do |v|
      # Configure promisc mode
      v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end

    # Configure minion_id identifier
    #node.vm.provision "shell", inline: "echo '#{node.vm.hostname}' > /etc/salt/minion_id"

    # Configure extra drives, assume they all exist if the first one is present:
    # Add 3 additional 4GB drives
    unless File.exist?(File.expand_path("~/#{node.vm.hostname}-sata-1.vdi"))
      node.vm.provider "virtualbox" do |v|

        # Add SATAController
        v.customize ["storagectl", :id, "--name", "SATAController", "--add", "sata"]

        # Add 3 disks
        ["1","2","3"].each do |disk|
          diskname = File.expand_path("~/#{node.vm.hostname}-sata-#{disk}.vdi")
          v.customize ['createhd', '--filename', diskname, '--size', 4096]
          v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', disk, '--device', 0, '--type', 'hdd', '--medium', diskname]
        end
      end
    end

    # salt-minion provisioning
    node.vm.provision :salt do |salt|
      salt.minion_config = "configs/minion"
      salt.minion_key = "keys/#{node.vm.hostname}.pem"
      salt.minion_pub = "keys/#{node.vm.hostname}.pub"
    end
  end

  config.vm.define "node02" do |node|
    node.vm.hostname = "node02"

    # Network for Admin/Public/Mgmt
    node.vm.network :private_network, ip: "192.168.33.32"

    # Flat Network
    node.vm.network :private_network, ip: "192.168.36.0", auto_config: false

    # Configure promisc mode
    node.vm.provider "virtualbox" do |v|
      # Configure promisc mode
      v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end

    # Configure minion_id identifier
    #node.vm.provision "shell", inline: "echo '#{node.vm.hostname}' > /etc/salt/minion_id"

    # Configure extra drives, assume they all exist if the first one is present:
    # Add 3 additional 4GB drives
    unless File.exist?(File.expand_path("~/#{node.vm.hostname}-sata-1.vdi"))
      node.vm.provider "virtualbox" do |v|

        # Add SATAController
        v.customize ["storagectl", :id, "--name", "SATAController", "--add", "sata"]

        # Add 3 disks
        ["1","2","3"].each do |disk|
          diskname = File.expand_path("~/#{node.vm.hostname}-sata-#{disk}.vdi")
          v.customize ['createhd', '--filename', diskname, '--size', 4096]
          v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', disk, '--device', 0, '--type', 'hdd', '--medium', diskname]
        end
      end
    end

    # salt-minion provisioning
    node.vm.provision :salt do |salt|
      salt.minion_config = "configs/minion"
      salt.minion_key = "keys/#{node.vm.hostname}.pem"
      salt.minion_pub = "keys/#{node.vm.hostname}.pub"
    end
  end

  config.vm.define "node03" do |node|
    node.vm.hostname = "node03"

    # Network for Admin/Public/Mgmt
    node.vm.network :private_network, ip: "192.168.33.33"

    # Flat Network
    node.vm.network :private_network, ip: "192.168.36.0", auto_config: false

    # Configure promisc mode
    node.vm.provider "virtualbox" do |v|
      # Configure promisc mode
      v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end

    # Configure minion_id identifier
    #node.vm.provision "shell", inline: "echo '#{node.vm.hostname}' > /etc/salt/minion_id"

    # Configure extra drives, assume they all exist if the first one is present:
    # Add 3 additional 4GB drives
    unless File.exist?(File.expand_path("~/#{node.vm.hostname}-sata-1.vdi"))
      node.vm.provider "virtualbox" do |v|

        # Add SATAController
        v.customize ["storagectl", :id, "--name", "SATAController", "--add", "sata"]

        # Add 3 disks
        ["1","2","3"].each do |disk|
          diskname = File.expand_path("~/#{node.vm.hostname}-sata-#{disk}.vdi")
          v.customize ['createhd', '--filename', diskname, '--size', 4096]
          v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', disk, '--device', 0, '--type', 'hdd', '--medium', diskname]
        end
      end
    end

    # salt-minion provisioning
    node.vm.provision :salt do |salt|
      salt.minion_config = "configs/minion"
      salt.minion_key = "keys/#{node.vm.hostname}.pem"
      salt.minion_pub = "keys/#{node.vm.hostname}.pub"
    end
  end

end
