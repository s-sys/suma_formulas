{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.kerberos is defined %}
{%- set kerberos = p.kerberos %}
suma_sssd_ad_configure_kerberos_file:
  file.managed:
    - name: /etc/krb5.conf
    - contents: |
        [libdefaults]
        dns_canonicalize_hostname = false
        rdns = false
        default_realm = {{ kerberos.fqdn_domain|upper }}
        default_ccache_name = /tmp/krb5cc_%{uid}
        
        [realms]
        {{ kerberos.fqdn_domain|upper }} = {
            kdc = {{ kerberos.domain_controller|lower }}
            default_domain = {{ kerberos.fqdn_domain|lower }}
            admin_server = {{ kerberos.domain_controller|lower }}
        }
        
        [logging]
        kdc = FILE:/var/log/krb5/krb5kdc.log
        admin_server = FILE:/var/log/krb5/kadmind.log
        default = SYSLOG:NOTICE:DAEMON
        
        [domain_realm]
        .{{ kerberos.fqdn_domain|lower }} = {{ kerberos.fqdn_domain|upper }}
        {{ kerberos.fqdn_domain|lower }} = {{ kerberos.fqdn_domain|upper }}
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - id: suma_sssd_ad_install_required_packages 
{%- endif %}

{%- endif %}
