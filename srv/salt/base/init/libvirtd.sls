libvirtd-service-magement:
  service.dead:
    - name: libvirtd
    - enable: False
  cmd.run: 
    - name: echo ok > /usr/local/src/ok &&  reboot
