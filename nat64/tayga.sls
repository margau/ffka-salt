install tayga:
  pkg.installed:
    - name: tayga

place tayga.conf:
  file.managed:
    - name: /etc/tayga.conf
    - source: salt://nat64/files/tayga.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
        dhcp: {{ pillar['dhcp'] }}

create tayga interface:
  cmd.script:
    - name: tayga_create_interface
    - source: salt://nat64/files/tayga_create_interface.sh.j2
    - template: jinja
    - cwd: /

service tayga:
  service.running:
    - name: tayga
    - enable: true
    - reload: true
    - watch:
      - file: place tayga.conf

setup tayga interface:
  cmd.script:
    - name: setup_tayga
    - source: salt://nat64/files/setup_tayga.sh.j2
    - template: jinja
    - cwd: /
