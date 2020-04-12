zookeeper-zoo-config:
  file.managed:
    - name: /opt/cloudera/parcels/CDH-5.14.4-1.cdh5.14.4.p0.3/etc/zookeeper/conf.dist/zoo.cfg
    - source: salt://modules/files/zoo.cfg.template
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: mkdir -p /data/bigdata/zookeeper/{dataLog,dataDir}
    - unless: test -d /data/bigdata/zookeeper/dataLog
    - require:
      - file: zookeeper-zoo-config
 
zookeeper-myid-config:
  file.managed:
    - name: /data/bigdata/zookeeper/dataDir/myid
    - source: salt://modules/files/myid.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      MYID: {{ grains['fqdn_ip4'][0][8:10]}}
    - require:
      - cmd: zookeeper-zoo-config

zookeeper-log4j-config:
  file.managed:
    - name: /opt/cloudera/parcels/CDH-5.14.4-1.cdh5.14.4.p0.3/etc/zookeeper/conf.dist/log4j.properties
    - source: salt://modules/files/log4j.properties.template
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: mkdir -p /data/bigdata/zookeeper/logs
    - unless: test -d /data/bigdata/zookeeper/logs
    - require:
      - file: zookeeper-log4j-config

zookeeper-service:
  cmd.run:
    - name: zookeeper-server restart
