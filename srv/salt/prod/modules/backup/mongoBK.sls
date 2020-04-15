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
  file.append:
    - name: /var/spool/cron/root
    - text:
      - 5 22 * * *  /usr/bin/bash /opt/script/mongoBK.sh &>/data/backup/mongo_backup.log
    - unless: grep  'mongoBK' /var/spool/cron/root
  cmd.run:
    - name: mkdir -p /data/backup/mongo|echo ok && chmod 600 /var/spool/cron/root
