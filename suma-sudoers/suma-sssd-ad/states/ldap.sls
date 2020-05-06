{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.kerberos is defined %}
{%- set kerberos = p.kerberos %}
{%- set options = p.options %}
{%- if options.change_nsswitch is sameas True %}
suma_sssd_ad_configure_openldap_file:
  file.managed:
    - name: /etc/openldap/ldap.conf
    - contents: |
        URI  ldap://{{ kerberos.domain_controller|lower }}
        BASE {%- set count = 0 -%}
        {%- for i in kerberos["fqdn_domain"].split(".") -%}
        {%- if count > 0 -%},{%- endif -%}dc={{ i }}
        {%- set count = count + 1 -%}{%- endfor -%}
        REFERRALS OFF
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - id: suma_sssd_ad_install_required_packages 
{%- endif %}
{%- endif %}

{%- endif %}
