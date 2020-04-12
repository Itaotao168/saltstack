firewalld-init:
  service.dead:
    - name: firewalld
    - enable: False
