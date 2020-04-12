limits-user-config:
  file.managed:
    - name: /etc/systemd/user.conf
    - source: salt://init/files/user.conf.template
    - user: root
    - group: root
    - mode: 644
