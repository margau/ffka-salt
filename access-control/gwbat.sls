zutrittskontrolle.git:
  git.latest:
    - name: https://gitlab.karlsruhe.freifunk.net/software/zutrittskontrolle.git
    - target: /usr/src/zutrittskontrolle
    - rev: master

/etc/systemd/system/zutrittskontrolle-export.service:
  file.managed:
    - contents: |
        [Unit]
        Description=sends current fastd key mapping to zutrittskontrolle server
        After=network.target

        [Service]
        Type=oneshot
        ExecStart=/usr/bin/python3 /usr/src/zutrittskontrolle/gwbat.py {{ pillar.community }} "http://zutrittskontrolle.frickelfunk.net:8000"
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - git: zutrittskontrolle.git

/etc/systemd/system/zutrittskontrolle-export.timer:
  file.managed:
    - contents: |
        [Timer]
        OnCalendar=
        OnCalendar=*:0/5
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - git: zutrittskontrolle.git

zutrittskontrolle-export.timer:
  service.running:
    - enable: True
    - require:
      - git: zutrittskontrolle.git
    - onchanges:
      - file: /etc/systemd/system/zutrittskontrolle-export.service
      - file: /etc/systemd/system/zutrittskontrolle-export.timer
