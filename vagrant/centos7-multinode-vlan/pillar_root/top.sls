openstack:
  "control01,node01,node02,node03":
    - match: list
    - {{ grains['os'] }}
    - devcluster.credentials
    - devcluster.environment
    - devcluster.networking
