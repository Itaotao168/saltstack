kafka-server-config:
  file.managed:
    - name: /opt/cloudera/parcels/KAFKA-3.1.1-1.3.1.1.p0.2/etc/kafka/conf.dist/server.properties
    - source: salt://modules/files/kafka-server.properties.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      IPADDR: {{ grains['fqdn_ip4'][0][8:10]}}
  cmd.run:
    - name: mkdir -p /data/bigdata/kafka/kafka-logs
    - unless: test -d /data/bigdata/kafka/kafka-logs
    - require:
      - file: kafka-server-config
 
kafka-meta-config:
  file.managed:
    - name: /var/local/kafka/data/meta.properties
    - source: salt://modules/files/kafka-meta.properties.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      IPADDR: {{ grains['fqdn_ip4'][0][8:10]}}
 
kafka-run-class-config:
  file.managed:
    - name: /opt/cloudera/parcels/KAFKA-3.1.1-1.3.1.1.p0.2/lib/kafka/bin/kafka-run-class.sh
    - source: salt://modules/files/kafka-run-class.sh.template
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: chmod +x /opt/cloudera/parcels/KAFKA-3.1.1-1.3.1.1.p0.2/lib/kafka/bin/kafka-run-class.sh
    - unless: test -x /opt/cloudera/parcels/KAFKA-3.1.1-1.3.1.1.p0.2/lib/kafka/bin/kafka-run-class.sh
