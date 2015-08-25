
mysql:
  root_password: "devpass"

rabbitmq:
  guest_password: "devpass"

databases:
  nova:
    db_name: "nova"
    username: "nova"
    password: "devpass"
  keystone:
    db_name: "keystone"
    username: "keystone"
    password: "devpass"
  cinder:
    db_name: "cinder"
    username: "cinder"
    password: "devpass"
  glance:
    db_name: "glance"
    username: "glance"
    password: "devpass"
  neutron:
    db_name: "neutron"
    username: "neutron"
    password: "devpass"
  heat:
    db_name: "heat"
    username: "heat"
    password: "devpass"

keystone:
  admin_token: "devtoken"
  roles:
    - "admin"
    - "heat_stack_owner"
    - "heat_stack_user"
  tenants:
    admin:
      users:
        admin:
          password: "devpass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
    service:
      users:
        cinder:
          password: "devpass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
        glance:
          password: "devpass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
        neutron:
          password: "devpass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
        nova:
          password: "devpass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
        heat:
          password: "devpass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
        heat-cfn:
          password: "devpass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
  services:
    glance:
      service_type: "image"
      endpoint:
        adminurl: "http://{0}:9292"
        internalurl: "http://{0}:9292"
        publicurl: "http://{0}:9292"
        endpoint_host_sls: glance
      description: "glance image service"
    keystone:
      service_type: "identity"
      endpoint:
        adminurl: "http://{0}:35357/v2.0"
        internalurl: "http://{0}:5000/v2.0"
        publicurl: "http://{0}:5000/v2.0"
        endpoint_host_sls: keystone
      description: "Openstack Identity"
    neutron:
      service_type: "network"
      endpoint:
        adminurl: "http://{0}:9696"
        internalurl: "http://{0}:9696"
        publicurl: "http://{0}:9696"
        endpoint_host_sls: neutron
      description: "Openstack network service"
    nova:
      service_type: "compute"
      endpoint:
        adminurl: "http://{0}:8774/v2/%(tenant_id)s"
        internalurl: "http://{0}:8774/v2/%(tenant_id)s"
        publicurl: "http://{0}:8774/v2/%(tenant_id)s"
        endpoint_host_sls: nova
      description: "nova compute service"
    cinder:
      service_type: "volume"
      endpoint:
        adminurl: "http://{0}:8776/v1/%(tenant_id)s"
        internalurl: "http://{0}:8776/v1/%(tenant_id)s"
        publicurl: "http://{0}:8776/v1/%(tenant_id)s"
        endpoint_host_sls: cinder
      description: "OpenStack Block Storage"
    cinderv2:
      service_type: "volumev2"
      endpoint:
        adminurl: "http://{0}:8776/v2/%(tenant_id)s"
        internalurl: "http://{0}:8776/v2/%(tenant_id)s"
        publicurl: "http://{0}:8776/v2/%(tenant_id)s"
        endpoint_host_sls: cinder
      description: "OpenStack Block Storage V2"
    heat:
      service_type: "orchestration"
      endpoint:
        adminurl: "http://{0}:8004/v1/%(tenant_id)s"
        internalurl: "http://{0}:8004/v1/%(tenant_id)s"
        publicurl: "http://{0}:8004/v1/%(tenant_id)s"
        endpoint_host_sls: heat
      description: "Openstack Orchestration Service"
    heat-cfn:
      service_type: "cloudformation"
      endpoint:
        adminurl: "http://{0}:8000/v1"
        internalurl: "http://{0}:8000/v1"
        publicurl: "http://{0}:8000/v1"
        endpoint_host_sls: heat
      description: "Orchestration CloudFormation"
