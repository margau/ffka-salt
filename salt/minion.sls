saltstack-repo:
  pkgrepo.managed:
    - humanname: saltstack
    - name: deb http://repo.saltstack.com/apt/debian/9/amd64/latest stretch main
    - file: /etc/apt/sources.list.d/saltstack.list
    - clean_file: True
    - key_url: https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub

salt-minion:
  pkg.installed:
    - fromrepo: saltstack-repo
    - require:
      - pkgrepo: saltstack-repo
  service.running:
    - enable: True
    - watch:
      - file: /etc/salt/minion.d

/etc/salt/minion_id:
  file.managed:
    - contents: {{ pillar.fqdn }}
    - user: root
    - group: root
    - mode: 644
    - onchanges:
      - pkg: salt-minion

/etc/salt/minion.d:
  file.recurse:
    - source: salt://salt/files/minion.d
    - clean: False # salt minion will create config files (starting with a _) which shold not be deleted
