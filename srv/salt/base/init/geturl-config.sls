geturl-file:
  cmd.run:
    - name: mkdir -p /opt/script
    - unless: test -d /opt/script
  file.managed:
    - name: /opt/script/getUrl.sh
    - source: salt://init/files/getUrl.sh
    - user: root
    - group: root
    - mode: 755
