{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_snmpd')  %}
{%- if p is defined and
    p.install is defined and
    p.install is sameas True %}
suma_snmpd_install_required_packages:
  pkg.installed:
    - pkgs:
      - net-snmp
      - snmp-mibs
{%- endif %}

{%- endif %}
