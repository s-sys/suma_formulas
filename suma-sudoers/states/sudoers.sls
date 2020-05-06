{%- from "suma-sudoers/map.jinja" import suma_sudoers with context %}
{%- if suma_sudoers is defined %}
{# Install sudo packages #}
install_sudo:
  pkg.installed:
    - name: sudo

{%- set options = suma_sudoers.sudoers_types %}

{# Define user alias for sudoers #}
{%- if options.checkbox_user_alias is sameas True %}
{%- set user_aliases = suma_sudoers.user_alias %}
{%- if user_aliases is defined %}
suma_populate_sudoers_user_aliases_include_file:
  file.managed:
    - name: /etc/sudoers.d/01_suma_user_alias
    - contents: |
        {%- set ns = namespace(count=0,text="") %}
        {%- for entry in user_aliases %}
          {%- set ns.count = 0 %}
          {%- set ns.text = "" %}
          {%- for item in entry.users %}
            {%- if ns.count > 0 %}
              {%- set ns.text = ns.text ~ ", " %}
            {%- endif %}
            {%- set ns.text = ns.text ~ item.user %}
            {%- set ns.count = ns.count + 1 %}
          {%- endfor %}
          {%- do salt.log.debug('suma_sudoers(user): var ns.text == ' ~ ns.text) %}
        User_Alias {{ entry.name }} = {{ ns.text }}
        {%- endfor %}
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - pkg: sudo
{%- endif %}
{%- else %}
suma_remove_sudoers_user_aliases_include_file:
  file.absent:
    - name: /etc/sudoers.d/01_suma_user_alias
{%- endif %}

{# Define command alias for sudoers #}
{%- if options.checkbox_command_alias is sameas True %}
{%- set command_aliases = suma_sudoers.command_alias %}
{%- if command_aliases is defined %}
suma_populate_sudoers_command_aliases_include_file:
  file.managed:
    - name: /etc/sudoers.d/02_suma_command_alias
    - contents: |
        {%- set ns = namespace(count=0,text="") %}
        {%- for entry in command_aliases %}
          {%- set ns.count = 0 %}
          {%- set ns.text = "" %}
          {%- for item in entry.commands %}
            {%- if ns.count > 0 %}
              {%- set ns.text = ns.text ~ ", " %}
            {%- endif %}
            {%- set ns.text = ns.text ~ item.command %}
            {%- set ns.count = ns.count + 1 %}
          {%- endfor %}
          {%- do salt.log.debug('suma_sudoers(command): var ns.text == ' ~ ns.text) %}
        Cmnd_Alias {{ entry.name }} = {{ ns.text }}
        {%- endfor %}
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - pkg: sudo
{%- endif %}
{%- else %}
suma_remove_sudoers_command_aliases_include_file:
  file.absent:
    - name: /etc/sudoers.d/02_suma_command_alias
{%- endif %}

{# Define host alias for sudoers #}
{%- if options.checkbox_host_alias is sameas True %}
{%- set host_aliases = suma_sudoers.host_alias %}
{%- if host_aliases is defined %}
suma_populate_sudoers_host_aliases_include_file:
  file.managed:
    - name: /etc/sudoers.d/03_suma_host_alias
    - contents: |
        {%- set ns = namespace(count=0,text="") %}
        {%- for entry in host_aliases %}
          {%- set ns.count = 0 %}
          {%- set ns.text = "" %}
          {%- for item in entry.hosts %}
            {%- if ns.count > 0 %}
              {%- set ns.text = ns.text ~ ", " %}
            {%- endif %}
            {%- set ns.text = ns.text ~ item.host %}
            {%- set ns.count = ns.count + 1 %}
          {%- endfor %}
          {%- do salt.log.debug('suma_sudoers(hosts): var ns.text == ' ~ ns.text) %}
        Host_Alias {{ entry.name }} = {{ ns.text }}
        {%- endfor %}
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - pkg: sudo
{%- endif %}
{%- else %}
suma_remove_sudoers_host_aliases_include_file:
  file.absent:
    - name: /etc/sudoers.d/03_suma_host_alias
{%- endif %}

{# Define runas alias for sudoers #}
{%- if options.checkbox_runas_alias is sameas True %}
{%- set runas_aliases = suma_sudoers.runas_alias %}
{%- if runas_aliases is defined %}
suma_populate_sudoers_runas_aliases_include_file:
  file.managed:
    - name: /etc/sudoers.d/04_suma_runas_alias
    - contents: |
        {%- set ns = namespace(count=0,text="") %}
        {%- for entry in runas_aliases %}
          {%- set ns.count = 0 %}
          {%- set ns.text = "" %}
          {%- for item in entry.runases %}
            {%- if ns.count > 0 %}
              {%- set ns.text = ns.text ~ ", " %}
            {%- endif %}
            {%- set ns.text = ns.text ~ item.runas %}
            {%- set ns.count = ns.count + 1 %}
          {%- endfor %}
          {%- do salt.log.debug('suma_sudoers(runas): var ns.text == ' ~ ns.text) %}
        Runas_Alias {{ entry.name }} = {{ ns.text }}
        {%- endfor %}
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - pkg: sudo
{%- endif %}
{%- else %}
suma_remove_sudoers_runas_aliases_include_file:
  file.absent:
    - name: /etc/sudoers.d/04_suma_runas_alias
{%- endif %}

{# Define user spec rules for sudoers #}
{%- set user_rules = suma_sudoers.user_rules %}
{%- if user_rules is defined %}
suma_populate_sudoers_user_spec_include_file:
  file.managed:
    - name: /etc/sudoers.d/05_suma_user_spec
    - contents: |
        {%- set ns = namespace(count=0,text="") %}
        {%- for entry in user_rules %}
          {%- set ns.count = 0 %}
          {%- set ns.text = "" %}
          {%- for item in entry.commands %}
            {%- if ns.count > 0 %}
              {%- set ns.text = ns.text ~ ", " %}
            {%- endif %}
            {%- set ns.text = ns.text ~ item.command %}
            {%- set ns.count = ns.count + 1 %}
          {%- endfor %}
          {%- do salt.log.debug('suma_sudoers(runas): var ns.text == ' ~ ns.text) %}
          {%- if entry.password is sameas True %}
            {%- set pwd_text = "PASSWD" %}
          {%- else %}
            {%- set pwd_text = "NOPASSWD" %}
          {%- endif %}
        {{ entry.user }} {{ entry.host }}=({{ entry.run }}) {{ pwd_text }}: {{ ns.text }}
        {%- endfor %}
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - pkg: sudo
{%- else %}
suma_remove_sudoers_user_spec_include_file:
  file.absent:
    - name: /etc/sudoers.d/05_suma_user_spec
{%- endif %}

{%- endif %}
