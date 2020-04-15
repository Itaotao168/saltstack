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

mysqlBK-cron:
  cmd.run:
    - name: mkdir -p /data/backup
    - unless: test -d /data/backup
  file.append:
    - name: /var/spool/cron/root
    - text:
      - 54 22 * * *  /usr/bin/bash /opt/script/mysqlBK.sh &>/data/backup/mysql_backup.log
    - unless: grep  'mysqlBK' /var/spool/cron/root

mysqlBK-root:
  cmd.run:
    - name: chmod 600 /var/spool/cron/root
