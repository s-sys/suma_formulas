{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.options is defined %}
{%- set options = p.options %}
{%- if options.change_nsswitch is sameas True %}
suma_sssd_ad_configure_nsswitch_file_passwd:
  file.replace:
    - name: /etc/nsswitch.conf
    - pattern: "^passwd: .*"
    - repl: "passwd: compat sss"
    - backup: False
    - require:
      - id: suma_sssd_ad_install_required_packages
      - id: suma_sssd_ad_enable_sssd_service

suma_sssd_ad_configure_nsswitch_file_group:
  file.replace:
    - name: /etc/nsswitch.conf
    - pattern: "^group: .*"
    - repl: "group: compat sss"
    - backup: False
    - require:
      - id: suma_sssd_ad_install_required_packages
      - id: suma_sssd_ad_enable_sssd_service
{%- endif %}
{%- endif %}

{%- endif %}
