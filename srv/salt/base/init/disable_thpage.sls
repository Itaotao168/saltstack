disable-thp:
  file.managed:
    - name: /usr/lib/systemd/system/disable-thp.service
    - source: salt://init/files/disable-thp.service
    - user: root
    - group: root
    - mode: 755
  service.running:
    - enable: True
    - reload: True
    - name: disable-thp
    - watch:
      - file: disable-thp
    - require:
      - file: disable-thp
