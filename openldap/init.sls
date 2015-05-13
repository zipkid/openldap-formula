# http://www.thegeekstuff.com/2015/01/openldap-linux/

{% if grains['os_family'] == 'Debian' %}
  {% set ldap_config_path = '/etc/ldap/' %}
  {% set pkgs = ['slapd', 'ldap-utils'] %}
{% elif grains['os_family'] == 'RedHat' %}
  {% set ldap_config_path = '/etc/openldap/' %}
  {% set pkgs = ['openldap-servers', 'openldap-clients'] %}
{% else %}
  {% set ldap_config_path = '/etc/openldap/' %}
  {% set pkgs = ['openldap'] %}
{% endif %}

{% set ldap = salt['pillar.get']('ldap:config', {}) %}

ldap:
  pkg.installed:
    - pkgs: {{ pkgs }}

{{ ldap_config_path }}/slapd.d/cn=config/olcDatabase={2}bdb.ldif:
  file.managed:
    - source: salt://openldap/files/olcDatabase={2}bdb.ldif
    - template: jinja
    - user: ldap
    - group: ldap
    - mode: 644
    - makedirs: True
    - context:
      ldap: {{ ldap }}
    - require:
      - pkg: ldap

{{ ldap_config_path }}/base.ldif:
  file.managed:
    - source: salt://openldap/files/base.ldif
    - template: jinja
    - user: ldap
    - group: ldap
    - mode: 644
    - makedirs: True
    - context:
      ldap: {{ ldap }}
    - require:
      - pkg: ldap

slapd:
  service.running:
    - require:
      - file: {{ ldap_config_path }}/slapd.d/cn=config/olcDatabase={2}bdb.ldif

# ldapsearch -x -W -D "{{ ldap['root_user'] }},{{ ldap['base'] }}" -b "{{ ldap['base'] }}" "(objectclass=*)"

# ldapadd -x -W -D "{{ ldap['root_user'] }},{{ ldap['base'] }}" -f /etc/openldap/base.ldif
