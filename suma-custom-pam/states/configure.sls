{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_custom_pam')  %}

{%- if p.enable is defined and
    p.enable is sameas True %}
{%- set options = p.options %}
suma_configure_pam_sshd_group_access:
  file.managed:
    - name: /etc/pam.d/sshd
    - contents: |
        #%PAM-1.0
        auth        requisite   pam_nologin.so
        auth        include     common-auth
        account     requisite   pam_nologin.so
        {%- for group in options.groups %}
        account     sufficient  pam_succeed_if.so user ingroup {{ group.name }}
        {%- endfor %}
        password    include     common-password
        session     required    pam_loginuid.so
        session     include     common-session
        session     optional    pam_lastlog.so   silent noupdate showfailed
        session     optional    pam_keyinit.so   force revoke
    - user: root
    - group: root
    - mode: "0644"
{%- elif p.enable is defined and
    p.enable is sameas False %}
suma_configure_pam_sshd_group_access:
  file.managed:
    - name: /etc/pam.d/sshd
    - contents: |
        #%PAM-1.0
        auth        requisite   pam_nologin.so
        auth        include     common-auth
        account     requisite   pam_nologin.so
        account     include     common-account
        password    include     common-password
        session     required    pam_loginuid.so
        session     include     common-session
        session     optional    pam_lastlog.so   silent noupdate showfailed
        session     optional    pam_keyinit.so   force revoke
    - user: root
    - group: root
    - mode: "0644"
{%- endif %}

{%- endif %}
