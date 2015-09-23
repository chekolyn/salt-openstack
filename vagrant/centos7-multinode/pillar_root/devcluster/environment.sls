environment_name: "devcluster"

openstack_series: "kilo"

db_engine: "mysql"

message_queue_engine: "rabbitmq"

reset: ""

debug_mode: False

system_upgrade: True

hosts:
  "control01": "192.168.34.21"
  "node01":    "192.168.34.31"
  "node02":    "192.168.34.32"
  "node03":    "192.168.34.33"

controller: "control01"
network: "control01"
storage:
  - "node01"
  - "node02"
  - "node03"
compute:
  - "node01"
  - "node02"
  - "node03"

cinder:
  volumes_group_name: "cinder-volumes"
  volumes_path: "/var/lib/cinder/cinder-volumes"
  volumes_group_size: "10"
  loopback_device: "/dev/loop0"

nova:
  cpu_allocation_ratio: "16"
  ram_allocation_ratio: "1.5"

glance:
  images:
    cirros:
      user: "admin"
      tenant: "admin"
      parameters:
        min_disk: 1
        min_ram: 0
        copy_from: "http://download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img"
        disk_format: qcow2
        container_format: bare
        is_public: True
        protected: False
