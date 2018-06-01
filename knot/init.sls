knot:
  pkgrepo.managed:
    - humanname: knot
    - name: deb https://deb.knot-dns.cz/knot/ {{ grains.lsb_distrib_codename }} main
    - key_url: https://deb.knot-dns.cz/knot/apt.gpg
    - file: /etc/apt/sources.list.d/knot.list
  pkg.installed: []

{% for config_file in ["knot", "remotes", "templates"] %}
/etc/knot/{{ config_file }}.conf:
  file.managed:
    - source: salt://knot/files/{{ config_file }}.conf.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: knot
{% endfor %}

/etc/knot/id_deploy:
  file.managed:
    - user: root
    - mode: 600
    - contents_pillar: dns:deployment_key
    - require:
      - pkg: knot

/etc/knot/zones:
  git.latest:
    - name: {{ pillar.dns.zones_repo }}
    - branch: master
    - target: /etc/knot/zones
    - identity: /etc/knot/id_deploy
    - force_reset: True
    - require:
       - pkg: packages_base
       - pkg: knot
       - file: /etc/knot/id_deploy

{% for zone_type in ["master", "slave"] %}
/etc/knot/zones.{{ zone_type }}.conf:
  file.symlink:
    - target: /etc/knot/zones/zones.{{ zone_type }}.conf
    - require:
      - pkg: knot
{% endfor %}