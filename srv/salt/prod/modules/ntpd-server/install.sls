ntp-server-installed:
  pkg.installed:
     - name: ntp
  cmd.run:
     - name: ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
     - unless: test -L /etc/localtime

ntp-server-config:
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://modules/files/ntpd-server.conf.template
    - user: root
    - group: root
    - mode: 644

ntp-server-log-config:
  file.managed:
    - name: /etc/sysconfig/ntpd
    - source: salt://modules/files/ntpd-server-log.conf.template
    - user: root
    - group: root
    - mode: 644

ntp-server-running:
  service.running:
    - name: ntpd
    - enable: True
