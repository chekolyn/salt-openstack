#!/bin/bash
# Disable NetworkManager

# Functions:
set_dhcp_eth0()
{
sudo cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << "DHCP"
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
DHCP
}


# Stop and Disable NetworkManager
/bin/systemctl stop NetworkManager
/bin/systemctl disable NetworkManager

# Config eth0 for network daemon
set_dhcp_eth0

# Start network daemon
/bin/systemctl enable network