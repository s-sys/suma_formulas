{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.kerberos is defined %}
{%- set kerberos = p.kerberos %}
{%- set fqdn = kerberos["fqdn_domain"].split(".") %}
suma_sssd_ad_configure_hosts_file:
  file.line:
    - name: /etc/hosts
    - mode: ensure
    - content: "{{ kerberos.ip_address }}  {{ kerberos.fqdn_domain }}  {{ fqdn[0] }}"
    - backup: False
    - location: end
    - require:
      - file: /etc/krb5.conf
{%- endif %}

{%- endif %}
