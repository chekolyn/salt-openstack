mysql:
  root_password: "devpass"

rabbitmq:
  user_name: "openstack"
  user_password: "devpass"

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

neutron:
  metadata_secret: "devpass"

keystone:
  admin_token: "devpass"
  roles:
    - "admin"
    - "heat_stack_owner"
    - "heat_stack_user"
  tenants:
    admin:
      users:
        admin:
          password: "devpass"
          roles:
            - "admin"
            - "heat_stack_owner"
          email: "salt@openstack.com"
          keystonerc:
            create: True
            path: /root/devcluster_adminrc
    service:
      users:
        cinder:
          password: "devpass"
          roles:
            - "admin"
          email: "salt@openstack.com"
        glance:
          password: "devpass"
          roles:
            - "admin"
          email: "salt@openstack.com"
        neutron:
          password: "devpass"
          roles:
            - "admin"
          email: "salt@openstack.com"
        nova:
          password: "devpass"
          roles:
            - "admin"
          email: "salt@openstack.com"
        heat:
          password: "devpass"
          roles:
            - "admin"
          email: "salt@openstack.com"
        heat-cfn:
          password: "devpass"
          roles:
            - "admin"
          email: "salt@openstack.com"
