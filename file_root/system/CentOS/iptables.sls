{% set system = salt['openstack_utils.system']() %}

system_firewalld_dead:
  service.dead:
    - name: {{ system['services']['firewalld'] }}
    - enable: False
    - require:
{% for pkg in system['packages'] %}
      - pkg: system_{{ pkg }}_install
{% endfor %}

systemd_reload_for_iptables:
  module.run:
    - name: service.systemctl_reload

system_iptables_running:
  service.running:
    - name: {{ system['services']['iptables'] }}
    - enable: True
    - require:
      - service: system_firewalld_dead
{% for pkg in system['packages'] %}
      - pkg: system_{{ pkg }}_install
{% endfor %}
      - module: systemd_reload_for_iptables

{% set count = 4 %}
{% for host in salt['pillar.get']( 'hosts' ) %}
  {% set host_ip = salt['openstack_utils.minion_ip']( host ) %}
  {% set count = count + 1 %}
open openstack node {{ host }} on firewall:
  iptables.insert:
    - position: {{ count }}
    - chain: INPUT
    - table: filter
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - source: {{ host_ip }}
    - save: True
    - require:
      - service: system_iptables_running
{% endfor %}

open novnc on firewall:
  iptables.insert:
    - position: {{ count + 1 }}
    - chain: INPUT
    - table: filter
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 6080
    - proto: tcp
    - save: True
    - require:
      - service: system_iptables_running

open http on firewall:
  iptables.insert:
    - position: {{ count + 2 }}
    - chain: INPUT
    - table: filter
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 80
    - proto: tcp
    - save: True
    - require:
      - iptables: open novnc on firewall
      - service: system_iptables_running

{% if salt['pillar.get']('horizon:https',False) %}
open https on firewall:
  iptables.insert:
    - position: {{ count + 3 }}
    - chain: INPUT
    - table: filter
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 443
    - proto: tcp
    - save: True
    - require:
      - iptables: open http on firewall
      - service: system_iptables_running
{% endif %}
