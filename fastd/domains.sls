{% for domain_id, domain in salt['pillar.get']('domains', {}).items() %}
{% for fastd in domain.get('fastd', {}).get('instances', []) %}

{% set fastd_ifname = salt['domain_networking.generate_ifname'](domain, 'fd', fastd['name']) %}

/etc/fastd/{{ domain_id }}/{{ fastd['name'] }}:
  file.directory:
    - mode: 755
    - makedirs: True
    - require:
      - pkg: fastd

/etc/fastd/{{ domain_id }}/{{ fastd['name'] }}/fastd.conf:
  file.managed:
    - source: salt://fastd/files/fastd_domain.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - context:
        domain: {{ domain }}
        fastd: {{ fastd }}
        fastd_id: {{ loop.index0 }}
        fastd_ifname: {{ fastd_ifname }}
    - require:
      - file: /etc/fastd/{{ domain_id }}/{{ fastd['name'] }}

fastd@{{ domain_id }}-{{ fastd['name'] }}.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/fastd/{{ domain_id }}/{{ fastd['name'] }}/fastd.conf

fastd@{{ domain_id }} in netdata:
  file.accumulated:
    - name: fastd-instances
    - filename: /etc/netdata/python.d/fastd.conf
    - text: {{ fastd_ifname }}
    - require_in:
        - file: /etc/netdata/python.d/fastd.conf

{% endfor %}
{% endfor %}
