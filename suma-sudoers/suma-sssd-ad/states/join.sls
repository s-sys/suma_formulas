{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.auth is defined %}
{%- set auth = p.auth %}
suma_sssd_ad_kinit:
  cmd.run:
    - name: echo '{{ auth.password }}' | kinit {{ auth.username }}
    - require:
      - id: suma_sssd_ad_install_required_packages 
      - id: suma_sssd_ad_configure_kerberos_file
      - id: suma_sssd_ad_configure_samba_file
      - id: suma_sssd_ad_configure_hosts_file
      - id: suma_sssd_ad_check_ntpd_is_working

suma_sssd_ad_join_ad_domain:
  cmd.run:
    - name: net ads join --no-dns-updates -k
    - require:
      - id: suma_sssd_ad_kinit
{%- endif %}

{%- endif %}
