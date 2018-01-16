{%- set hopglass_server_version = "v0.1.3" -%}

hopglass:
  user.present

hopglass-server.git:
  git.latest:
    - name: https://github.com/hopglass/hopglass-server.git
    - target: /home/hopglass/server
    - user: hopglass
    - rev: {{ hopglass_server_version }}
    - force_fetch: True
    - force_reset: True
    - require:
      - user: hopglass

/home/hopglass/server.git:
  npm.bootstrap:
    - user: hopglass
    - silent: False
    - require:
      - git: hopglass-server.git
      - user: hopglass
    - watch:
      - git: hopglass-server.git

/etc/hopglass-server:
  file.directory:
    - user: hopglass
    - group: hopglass
    - mode: 755

/lib/systemd/system/hopglass-server@.service:
  file.managed:
    - user: root
    - group: root
    - source: salt://hopglass/files/hopglass-server@.service.j2
    - template: jinja

{% for hopglass_instance in ["default"] %}
/etc/hopglass-server/{{ hopglass_instance }}:
  file.directory:
    - user: hopglass
    - group: hopglass
    - mode: 755
    - require:
      - file: /etc/hopglass-server

/etc/hopglass-server/{{ hopglass_instance }}/config.json:
  file.managed:
    - user: hopglass
    - group: hopglass
    - source: salt://hopglass/files/instances/{{ hopglass_instance }}/config.js.j2
    - template: jinja
    - require:
      - file: /etc/hopglass-server/{{ hopglass_instance }}
{% endfor %}