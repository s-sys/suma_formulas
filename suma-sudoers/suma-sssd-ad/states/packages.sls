{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.options is defined %}
{%- set options = p.options %}
{%- if options.install_packages is sameas True %}
suma_sssd_ad_install_required_packages:
  pkg.installed:
    - pkgs:
      - krb5-client
      - samba-client
      - openldap2-client
      - sssd
      - sssd-ad
{%- endif %}
{%- endif %}

{%- endif %}
