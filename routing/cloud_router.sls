{%- for bird, af in [['bird', 'ipv4'], ['bird6', 'ipv6']] %}
{% for name, peer in salt['pillar.get']('routing:internal_upstream', {}).items() %}

/etc/bird/{{ bird }}.d/50-cloud-router-upstream-{{ name }}.conf:
  file.managed:
    - source: salt://routing/files/{{ bird }}.d/cloud-router.conf
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - context:
        name: {{ name }}
        peer: {{ peer }}
        af: {{ af }}
    - watch_in:
      - service: {{ bird }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d

{% endfor %}
{% endfor %}
