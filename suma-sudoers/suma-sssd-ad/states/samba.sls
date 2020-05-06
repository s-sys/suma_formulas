{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.kerberos is defined %}
{%- set kerberos = p.kerberos %}
{%- set fqdn = kerberos["fqdn_domain"].split(".") %}
suma_sssd_ad_configure_samba_file:
  file.managed:
    - name: /etc/samba/smb.conf
    - contents: |
        [global]
        workgroup = {{ fqdn[0] }}
        client signing = yes
        client use spnego = yes
        kerberos method = secrets and keytab
        realm = {{ kerberos.fqdn_domain|upper }}
        security = ADS
        create krb5 conf = no
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - id: suma_sssd_ad_install_required_packages 
{%- endif %}

{%- endif %}
