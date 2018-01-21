
grafana:
  pkgrepo.managed:
    - humanname: grafana
    - name: deb https://packagecloud.io/grafana/stable/debian/ stretch main
    - key_url: https://packagecloud.io/gpg.key
    - file: /etc/apt/sources.list.d/grafana.list
  pkg.installed: []

/etc/default/grafana-server:
  file.managed:
    - source: salt://grafana/files/grafana-server-default
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: grafana

/etc/grafana/grafana.ini:
  file.managed:
    - source: salt://grafana/files/grafana.ini.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: grafana

grafana-server:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/default/grafana-server
      - file: /etc/grafana/grafana.ini
    - require:
      - pkg: grafana

prometheus_monitor_grafana:
  grafana4_datasource.present:
    - name: monitor.frickelfunk.net
    - type: prometheus
    - url: http://localhost:9090
    - access: proxy
    - is_default: true
