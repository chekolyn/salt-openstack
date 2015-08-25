# vi: set ft=ruby :

# This will configure the libvirt hypervisor settings
# NOTE: Using Vagrant nugrant plugin to abstract the hipervisor settings
# Load common config.libvirt.rb
begin
  load '../common/config.libvirt.rb'
rescue LoadError
  # ignore
end

Vagrant.configure("2") do |config|

  config.vm.box = "uvsmtid/centos-7.0-minimal"
  config.vm.box_url = "https://atlas.hashicorp.com/uvsmtid/boxes/centos-7.0-minimal/versions/1.0.0/providers/libvirt.box"

  # Centos7 Disable Firewall
  config.vm.provision "shell", inline: "systemctl disable firewalld",
    run: "always"
  config.vm.provision "shell", inline: "systemctl stop firewalld",
    run: "always"

  # Configure eth0 via script, will disable NetworkManager and enable legacy network daemon:
  config.vm.provision "shell", path: "../common/disable_network_manager.sh"

  ### NOTE:Hypervisor configuration abstracted at: "config.libvirt.rb" ###
  ########################################################################

  ### VMs definitions START ####
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

    # salt-master provisioning
    node.vm.provision :salt do |salt|
      salt.install_master = true
      salt.always_install = true
      salt.master_config = "configs/master"
      salt.run_highstate = false
      salt.master_key = '../common/keys/master.pem'
      salt.master_pub = '../common/keys/master.pub'

      salt.minion_config = "configs/minion"
      salt.minion_key = '../common/keys/master.pem'
      salt.minion_pub = '../common/keys/master.pub'

      salt.seed_master = {
        'master' => '../common/keys/master.pub',
        'allinone' => '../common/keys/allinone.pub'
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

    # salt-minion provisioning
    node.vm.provision :salt do |salt|
      salt.minion_config = "configs/minion"
      salt.minion_key = "../common/keys/#{node.vm.hostname}.pem"
      salt.minion_pub = "../common/keys/#{node.vm.hostname}.pub"
      salt.run_highstate = false
    end
  end
  ### VMs definitions END ####

end
