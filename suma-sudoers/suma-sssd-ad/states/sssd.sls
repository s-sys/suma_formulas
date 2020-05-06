{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_sssd_ad')  %}
{%- if p is defined and
    p.kerberos is defined %}
{%- set kerberos = p.kerberos %}
suma_sssd_ad_configure_sssd_file:
  file.managed:
    - name: /etc/sssd/sssd.conf
    - contents: |
        [sssd]
        config_file_version = 2
        reconnection_retries = 5
        services = nss, pam
        domains = {{ kerberos.fqdn_domain|lower }}
        
        [nss]
        filter_users = root
        filter_groups = root
        
        [pam]
        offline_credentials_expiration = 5
        
        [domain/{{ kerberos.fqdn_domain|lower }}]
        id_provider = ad
        auth_provider = ad
        cache_credentials = true
        enumerate = false
        pwd_expiration_warning = 7
        ldap_search_timeout = 15
        ldap_network_timeout = 15
        ldap_enumeration_search_timeout = 60
        override_homedir = /home/%d/%u
        dns_discovery_domain = {{ kerberos.fqdn_domain|lower }}
        # ad_server = _srv_, {{ kerberos.domain_controller|lower }}
        # debug_level = 7
    - user: root
    - group: root
    - mode: "0600"
    - makedirs: True
    - require:
      - id: suma_sssd_ad_install_required_packages 

suma_sssd_ad_disable_nscd_service:
  service.dead:
    - name: nscd.service
    - enable: False

suma_sssd_ad_enable_sssd_service:
  service.running:
    - name: sssd.service
    - enable: True
    - require:
      - id: suma_sssd_ad_install_required_packages
      - id: suma_sssd_ad_disable_nscd_service
      - id: suma_sssd_ad_configure_sssd_file
{%- endif %}

{%- endif %}
