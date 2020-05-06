{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.options is defined and
    p.options.change_resolve is sameas True %}
{%- set kerberos = p.kerberos %}
suma_sssd_ad_configure_resolv_file:
  file.line:
    - name: /etc/resolv.conf
    - mode: ensure
    - content: "nameserver {{ kerberos.ip_address }}"
    - backup: False
    - before: nameserver
    - require:
      - file: /etc/krb5.conf
{%- endif %}

{%- endif %}
