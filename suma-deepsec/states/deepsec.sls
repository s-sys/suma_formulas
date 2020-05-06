{% if grains['os'] == 'SUSE' and
      (grains['osmajorrelease']|int == 12 or
      grains['osmajorrelease']|int == 15) %}

{%- set p = salt['pillar.get']('suma_deepsec')  %}
{%- set package_name = "ds_agent" %}
{%- set control_file = "/opt/ds_agent/setup.OK" %}

{%- if p is defined and
    p.options is defined %}
{%- set options = p.options %}
{%- if options.force_registration is sameas True %}
remove_deep_security_control_file:
  file.absent:
    - name: {{ control_file }}
    - require_in:
      - id: install_deep_security_agent
{%- endif %}

{# Install Deep Security agent #}
install_deep_security_agent:
  pkg.installed:
    - name: {{ package_name }}

register_deep_security_step1:
  cmd.run:
    - name: /opt/ds_agent/dsa_control -r
    - require:
      - pkg: {{ package_name }}
    - onlyif:
      - rpm -q {{ package_name }}
      - test ! -f {{ control_file }}

register_deep_security_step2:
  cmd.run:
    - name: /opt/ds_agent/dsa_control -a {{ options.activation_url }}
    - require:
      - id: register_deep_security_step1
    - onlyif:
      - rpm -qa {{ package_name }}

register_deep_security_step3:
  file.managed:
    - name: {{ control_file }}
    - contents: ""
    - user: root
    - group: root
    - mode: "0640"
    - require:
      - id: register_deep_security_step2
{%- endif %}

{%- endif %}
