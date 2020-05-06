{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.options is defined %}
{%- set options = p.options %}
{%- if options.change_pam is sameas True %}
suma_sssd_ad_change_pam_sssd_step1:
  cmd.run:
    - name: pam-config --add --sss
    - require:
      - id: suma_sssd_ad_install_required_packages 

suma_sssd_ad_change_pam_sssd_step2:
  cmd.run:
    - name: pam-config --add --mkhomedir
    - require:
      - id: suma_sssd_ad_change_pam_sssd_step1
{%- endif %}
{%- endif %}

{%- endif %}
