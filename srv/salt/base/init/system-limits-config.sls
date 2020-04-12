limits-system-config:
  file.managed:
    - name: /etc/systemd/system.conf
    - source: salt://init/files/system.conf.template
    - user: root
    - group: root
    - mode: 644
