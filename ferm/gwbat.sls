/etc/ferm/conf.d/gwbat.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://ferm/files/gwbat.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
    - require:
      - file: /etc/ferm/conf.d