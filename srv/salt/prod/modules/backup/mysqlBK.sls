mysqlBK-file:
  cmd.run:
    - name: mkdir -p /opt/script
    - unless: test -d /opt/script
  file.managed:
    - name: /opt/script/mysqlBK.sh
    - source: salt://modules/files/mysqlBK.sh
    - user: root
    - group: root
    - mode: 755
