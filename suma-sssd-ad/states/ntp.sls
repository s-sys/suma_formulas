{% if grains['os'] == 'SUSE' %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.options is defined %}
{%- set options = p.options %}
{%- if grains['osmajorrelease']|int == 12 and
    options.check_ntp is sameas True %}
suma_sssd_ad_check_ntpd_is_working:
  cmd.run:
    - name: ntpstat | LC_ALL=C grep -i -e "^synchronised.*"
    - failhard: True

{%- elif grains['osmajorrelease']|int == 15 and
    options.check_ntp is sameas True %}
suma_sssd_ad_check_ntpd_is_working:
  cmd.run:
    - name: chronyc tracking | grep -i -e "^leap status.*normal"
    - failhard: True
{%- endif %}
{%- endif %}

{%- endif %}
