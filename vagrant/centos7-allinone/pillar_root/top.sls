openstack:
  "allinone":
    - match: list
    - {{ grains['os'] }}
    - devcluster.credentials
    - devcluster.environment
    - devcluster.networking
