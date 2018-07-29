include:
  - common.debian_testing

/etc/apt/preferences.d/kea-dhcp4-server-testing:
  file.managed:
    - contents: |
        Package: kea-dhcp4-*
        Pin: release n=testing
        Pin-Priority: 800

kea-dhcp4-server:
  pkg.installed:
    - fromrepo: testing
    - require:
      - pkgrepo: testing
      - file: /etc/apt/preferences.d/kea-dhcp4-server-testing

/etc/kea/kea-dhcp4.conf:
  file.managed:
    - source: salt://dhcpv4/files/dhcpv4.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600

kea-dhcp4-server.service:
  service.running:
    - enable: True
    - watch:
      - pkg: kea-dhcp4-server
      - file: /etc/kea/kea-dhcp4.conf