{% for vhost in salt['pillar.get']('nginx:vhosts', []) %}

{%- set name = vhost.site_name -%}
{%- set domainset = salt['pillar.get']('domainsets:' ~ vhost.domainset, []) -%}

/etc/nginx/sites-available/{{ name }}.conf:
  file.managed:
    - source: salt://nginx/files/sites/{{ name }}.conf.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      site_name: '{{ name }}'
      hostnames: '{{ domainset|join(' ') }}'
      vhost: {{ vhost }}
      certificate_filename: {{ domainset[0] }}
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/{{ name }}.conf:
{% if not vhost.get('disabled', False) %}
  file.symlink:
    - target: /etc/nginx/sites-available/{{ name }}.conf
{% else %}
  file.absent
{% endif %}

{% if vhost.get('webroot', False) %}
/srv/www/{{ name }}/htdocs/:
  file.directory:
    - user: www-data
    - makedirs: True
{% endif %}

/var/log/nginx/{{ name }}:
  file.directory:
    - user: www-data

{%- if vhost.get('custom_states') %}
include:
  - {{  }}
{% endif %}

{% endfor %}

{% for vhost in salt['pillar.get']('nginx:vhosts', []) | selectattr("custom_states", True) %}
{%- if loop.first -%}
include:
{% endif %}
  - nginx.sites.{{ vhost.site_name }}
{% endfor %}
