lo:
  file.managed:
    - name: /etc/network/interfaces.d/lo.cfg
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://network/files/lo.j2
    - template: jinja
