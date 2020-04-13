{%- set deploy_dir = salt['pillar.get']('meshviewer:webroot', None) -%}

meshviewer:
  user.present

yarn:
  pkgrepo.managed:
    - humanname: yarn
    - name: deb https://dl.yarnpkg.com/debian/ stable main
    - key_url: https://dl.yarnpkg.com/debian/pubkey.gpg
    - file: /etc/apt/sources.list.d/yarn.list
    - require_in:
      - pkg: yarn
  pkg.latest:
    - pkgs:
      - yarn


/home/meshviewer/meshviewer.git:
  git.latest:
    - name: https://github.com/freifunk-ffm/meshviewer.git
    - target: /home/meshviewer/meshviewer.git
    - user: meshviewer
    - force_fetch: True
    - force_reset: True
    - require:
      - pkg: nodejs
      - user: meshviewer

meshviewer_yarn_install:
  cmd.run:
    - onchanges:
      - git: /home/meshviewer/meshviewer.git
    - require:
      - pkg: yarn
      - git: /home/meshviewer/meshviewer.git
    - cwd: /home/meshviewer/meshviewer.git
    - runas: meshviewer
    - name: yarn && yarn add gulp-cli

config.js:
  file.managed:
    - name: /home/meshviewer/meshviewer.git/config.js
    - user: www-data
    - group: www-data
    - source: salt://meshviewer/files/config.js.j2
    - template: jinja
    - require:
      - git: /home/meshviewer/meshviewer.git
    - watch:
      - git: /home/meshviewer/meshviewer.git
    - context:
      api_endpoint: {{ salt['pillar.get']('meshviewer:api_endpoint') }}

meshviewer_gulp:
  cmd.run:
    - onchanges:
      - cmd: meshviewer_yarn_install
      - file: config.js
    - require:
       - cmd: meshviewer_yarn_install
       - git: /home/meshviewer/meshviewer.git
    - cwd: /home/meshviewer/meshviewer.git
    - runas: meshviewer
    - name: ./node_modules/.bin/gulp


{% if deploy_dir %}
meshviewer_deploy:
  rsync.synchronized:
    - name: {{ deploy_dir }}
    - source: /home/meshviewer/meshviewer.git/build/
    - force: True
    - delete: True
    - require:
       - cmd: meshviewer_gulp
       - test: nginx_meshviewer
    - onchanges:
       - git: /home/meshviewer/meshviewer.git
{% endif %}


include:
  - nodejs
