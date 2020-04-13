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
