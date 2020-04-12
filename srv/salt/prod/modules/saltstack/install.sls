saltstack-minion-install:
  pkg.installed:
    - name: salt-minion
  file.managed:
    - name: /etc/salt/minion
    - source: salt://modules/files/minion.template
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: salt-minion
    - enable: True
