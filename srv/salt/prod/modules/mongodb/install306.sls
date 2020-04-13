{% set MONGODB_PATH='/data/mongodb' %}
{% set MONGODB_VERSION='mongodb-linux-x86_64-3.0.6' %}
mongo-install306:
  archive.extracted:
    - name: /usr/local/
    - source: salt://modules/files/{{ MONGODB_VERSION }}.tgz
    - source_hash: md5=68F58028BB98FF7B97C4B37EBC20380C
    - archive_format: tar
    - tar_options: v
    - user: root
    - group: root
    - if_missing: /usr/local/{{ MONGODB_VERSION }}
  cmd.run:
    - name: groupadd mongo | echo ok && useradd -g mongo -s /sbin/nologin mongo |echo ok && ln -s /usr/local/{{ MONGODB_VERSION }} /usr/local/mongodb && ln -s /usr/local/mongodb/bin/mongo /usr/bin/mongo|echo ok && chown -R mongo:mongo /usr/local/{{ MONGODB_VERSION }} /usr/local/mongodb
    - unless: test -d /usr/local/{{ MONGODB_VERSION }} && test -L /usr/local/mongodb
    - require:
      - archive: mongo-install306

mongo-config306:
  cmd.run:
    - name: mkdir -p {{ MONGODB_PATH }}/{logs,data} && chown -R mongo:mongo {{ MONGODB_PATH }}/{logs,data}
    - unless: test -d {{ MONGODB_PATH }}/data
  file.managed:
    - name: /usr/local/mongodb/bin/mongodb.conf 
    - source: salt://modules/files/mongodb.conf.template 
    - user: mongo
    - group: mongo
    - mode: 644
    - template: jinja
    - defaults: 
      MONGODB_PATH: {{ MONGODB_PATH }}
    - require:
      - cmd: mongo-config306


mongo-service306:
  pkg.installed:
    - pkgs:
      - numactl 
  file.managed:
    - name: /usr/lib/systemd/system/mongod.service 
    - source: salt://modules/files/mongod.service.template
    - user: root
    - group: root
    - mode: 755

  service.running:
    - enable: True
    - reload: True
    - name: mongod
    - watch:
      - file: mongo-service306
    - require:
      - cmd: mongo-install306
      - file: mongo-config306
      - file: mongo-service306
      - pkg: mongo-service306
