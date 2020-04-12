nodejs-install:
  archive.extracted:
    - name: /usr/local/
    - source: salt://modules/files/node-v12.4.0-linux-x64.tar.gz
    - source_hash: md5=75341c471626e3155079041fc8737bab
    - archive_format: tar
    - tar_options: v
    - user: root
    - group: root
    - if_missing: /usr/local/node-v12.4.0-linux-x64
  cmd.run:
    - name: ln -s /usr/local/node-v12.4.0-linux-x64/bin/npm /usr/bin/npm && ln -s /usr/local/node-v12.4.0-linux-x64/bin/node /usr/bin/node && npm -v && node -v
    - unless: test -d /usr/local/node-v12.4.0-linux-x64 && test -L /usr/bin/npm
    - require:
      - archive: nodejs-install

pm2-install:
  archive.extracted:
    - name: /usr/local/node-v12.4.0-linux-x64/lib/node_modules
    - source: salt://modules/files/pm2.tar.gz
    - source_hash: md5=ac2b02d911768b2a8abb9d7148034016
    - archive_format: tar
    - tar_options: v
    - user: root
    - group: root
    - if_missing: /usr/local/node-v12.4.0-linux-x64/lib/node_modules/pm2
  cmd.run:
    - name: ln -s /usr/local/node-v12.4.0-linux-x64/lib/node_modules/pm2/pm2  /usr/bin/pm2
    - unless: test -d /usr/local/node-v12.4.0-linux-x64/lib/node_modules/pm2 && test -L /usr/bin/pm2
    - require:
      - archive: pm2-install


pm2-service:
  cmd.run:
    - name: pm2 startup && pm2 save
    - unless: test -f /etc/init.d/pm2-root
