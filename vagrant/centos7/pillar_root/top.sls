openstack:
  '*':
   - test
  "control01,node01,node02,node03":
    - match: list
    - {{ grains['os'] }}
    - devcluster.cluster_resources
    - devcluster.access_resources
    - devcluster.network_resources
