ntp-client:
  pkg.installed:
    - pkgs:
      - ntp 
      - ntpdate
  cmd.run:
    - name: ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && ntpdate -u 10.10.0.62
    - unless: test -f /sbin/ntpd
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://modules/files/ntp.conf.template
    - user: root
    - group: root
    - mode: 644

ntp-client-log-config:
  file.managed:
    - name: /etc/sysconfig/ntpd
    - source: salt://modules/files/ntpd-server-log.conf.template
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: systemctl restart ntpd
    - unless: test -f /var/log/ntpstats/ntpd.log

ntp-client-service:
  service.running:
    - name: ntpd
    - reload: True
    - enable: True
    - watch:
      - file: /etc/ntp.conf
