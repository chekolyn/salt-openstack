neutron:
  integration_bridge: "br-int"

  external_bridge: "br-ex"

  single_nic:
    enable: False
    interface: "eth0"
    set_up_script: "/root/br-proxy.sh"

  type_drivers:
    flat:
      physnets:
        physnet0:
          bridge: "br-ex"
          hosts:
            "control01": "eth2"
            "node01": "eth2"
            "node02": "eth2"
            "node03": "eth2"
    vlan:
      physnets:
        physnet1:
          bridge: "br-data"
          vlan_range: "1000:1010"
          hosts:
            "control01": "eth3"
            "node01": "eth3"
            "node02": "eth3"
            "node03": "eth3"

  tunneling:
    enable: False
    types:
      - vxlan
    bridge: "br-tun"

  networks:
    public:
      user: "admin"
      tenant: "admin"
      shared: True
      admin_state_up: True
      router_external: True
      provider_physical_network: "physnet0"
      provider_network_type: "flat"
      subnets:
        public_subnet:
          cidr: '192.168.37.0/24'
          allocation_pools:
            - start: '192.168.37.100'
              end: '192.168.37.200'
          enable_dhcp: True
          gateway_ip: '192.168.37.1'
          dns_nameservers:
            - 8.8.8.8
            - 8.8.4.4
    private:
      user: "admin"
      tenant: "admin"
      admin_state_up: True
      subnets:
        private_subnet:
          cidr: '10.0.1.0/24'
          dns_nameservers:
            - 8.8.8.8

  routers:
    router01:
      user: "admin"
      tenant: "admin"
      interfaces:
        - "private_subnet"
      gateway_network: "public"

  security_groups:
    default:
      user: admin
      tenant: admin
      description: 'default'
      rules: # Allow all traffic on the default security group
        - direction: "ingress"
          ethertype: "IPv4"
          protocol: "TCP"
          port_range_min: "1"
          port_range_max: "65535"
          remote_ip_prefix: "0.0.0.0/0"
        - direction: "ingress"
          ethertype: "IPv4"
          protocol: "UDP"
          port_range_min: "1"
          port_range_max: "65535"
          remote_ip_prefix: "0.0.0.0/0"
        - direction: ingress
          protocol: ICMP
          remote_ip_prefix: '0.0.0.0/0'
