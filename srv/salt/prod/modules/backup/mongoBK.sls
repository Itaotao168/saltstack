mongoBK-file:
  cmd.run:
    - name: mkdir -p /opt/script
    - unless: test -d /opt/script
  file.managed:
    - name: /opt/script/mongoBK.sh
    - source: salt://modules/files/mongoBK.sh
    - user: root
    - group: root
    - mode: 755

mongoBK-cron:
  cmd.run:
    - name: mkdir -p /data/backup
    - unless: test -d /data/backup
  file.append:
    - name: /var/spool/cron/root
    - text:
      - 25 22 * * *  /usr/bin/bash /opt/script/mongoBK.sh &>/data/backup/mongo_backup.log
    - unless: grep  'mongoBK' /var/spool/cron/root

mongoBK-root:
  cmd.run:
    - name: chmod 600 /var/spool/cron/root
