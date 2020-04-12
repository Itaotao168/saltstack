{% set MONGODB_PATH='/home/data/mongodb' %}
mongo-install:
  archive.extracted:
    - name: /usr/local/
    - source: salt://modules/files/mongodb-linux-x86_64-rhel70-3.6.8.tgz
    - source_hash: md5=c855e5543200d1772b3ac3d3e701ca15
    - archive_format: tar
    - tar_options: v
    - user: root
    - group: root
    - if_missing: /usr/local/mongodb-linux-x86_64-rhel70-3.6.8
  cmd.run:
    - name: ln -s /usr/local/mongodb-linux-x86_64-rhel70-3.6.8 /usr/local/mongodb
    - unless: test -d /usr/local/mongodb-linux-x86_64-rhel70-3.6.8 && test -L /usr/local/mongodb
    - require:
      - archive: mongo-install

mongo-config:
  cmd.run:
    - name: mkdir -p {{ MONGODB_PATH }}/{logs,data}
    - unless: test -d {{ MONGODB_PATH }}/data
  file.managed:
    - name: /usr/local/mongodb/bin/mongodb.conf 
    - source: salt://modules/files/mongodb.conf.template 
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults: 
      MONGODB_PATH: {{ MONGODB_PATH }}
    - require:
      - cmd: mongo-config


mongo-service:
  pkg.installed:
    - pkgs:
      - numactl 
  file.managed:
    - name: /usr/lib/systemd/system/mongod.service 
    - source: salt://modules/files/mongod.service.template
    - user: root
    - group: root
    - mode: 644

  service.running:
    - enable: True
    - reload: True
    - name: mongod
    - watch:
      - file: mongo-service
    - require:
      - cmd: mongo-install
      - file: mongo-config
      - file: mongo-service
      - pkg: mongo-service
