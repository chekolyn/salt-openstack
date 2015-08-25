openstack:
  "allinone":
    - match: list
    - {{ grains['os'] }}
    - devcluster.cluster_resources
    - devcluster.access_resources
    - devcluster.network_resources
