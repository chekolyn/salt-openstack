
neutron:
  intergration_bridge: "br-int"

  external_bridge: "br-flat"

  single_nic:
    enable: "false"
    #interface: "<interface_name>"

  metadata_secret: "devtoken"

  type_drivers:
    flat:
      physnets:
        physnet1:
          bridge: "br-flat"
          hosts:
            "allinone": "eth2"

# No vlan for flat networks
    #vlan:
    #  physnets:
    #    <physnet_name>:
    #      bridge: "<bridge_name>"
    #      vlan_range: "<start_vlan>:<end_vlan>"
    #      hosts:
    #        "<minion_id>": "<interface_name>"

  networks:
    default_net:
      user: "admin"
      tenant: "admin"
      provider_physical_network: "physnet1"
      provider_network_type: "flat"
      shared: "True"
      admin_state_up: "True"
      router_external: "True"
      subnets:
        default_subnet:
          cidr: '192.168.36.0/24'
          allocation_pools:
            - start: '192.168.36.100'
              end: '192.168.36.200'
          enable_dhcp: "True"
          dns_nameservers:
            - 8.8.8.8
            - 8.8.4.4

# No routers for flat network
#  routers:
#    default_router:
#      user: "admin"
#      tenant: "admin"
#      interfaces:
#        - "<subnet_name_1>"
#        - "<subnet_name_2>"
#      gateway_network: "<network_name>"

  security_groups:
    default:
      user: "admin"
      tenant: "admin"
      description: "Default Security Group"
      rules:
        - protocol: "tcp"
          direction: "ingress"
          from-port: "22"
          to-port: "22"
          cidr: '0.0.0.0/0'
