{% for name, tunnels in salt['pillar.get']('network:gre', {}).items() %}

gre_{{ name }}:
  file.managed:
    - name: /etc/network/interfaces.d/gre_{{ name }}.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/gre.j2
    - template: jinja
    - context:
        tunnels: {{ tunnels }}

{% endfor %}