{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_snmpd')  %}
{%- if p is defined and
    p.identity is defined and 
    p.access is defined %}
{%- set identity = p.identity %}
{%- set access = p.access %}
suma_snmpd_configure_snmp_file:
  file.managed:
    - name: /etc/snmp/snmpd.conf
    - contents: |
        syslocation {{ identity.location }}
        syscontact {{ identity.contact }} ({{ identity.email }})
        rocommunity '{{ access.community }}' {{ access.network }}
        
        view AllView included {{ access.root_oid }}
        com2sec AllUser default '{{ access.community }}'
        group AllGroup v2c AllUser
        access AllGroup "" v2c noauth exact AllView none none
    - user: root
    - group: root
    - mode: "0600"

suma_snmpd_enable_snmp_service:
  service.running:
    - name: snmpd.service
    - enable: True
    - require:
      - id: suma_snmpd_install_required_packages
      - id: suma_snmpd_configure_snmp_file
{%- endif %}

{%- endif %}
