kernel-lt-file:
  file.managed:
    - name: /usr/local/src/kernel-lt-4.4.213-1.el7.elrepo.x86_64.rpm
    - source: salt://init/files/kernel-lt-4.4.213-1.el7.elrepo.x86_64.rpm
    - user: root
    - group: root
    - mode: 644

kernel-lt-devel-file:
  file.managed:
    - name: /usr/local/src/kernel-lt-devel-4.4.213-1.el7.elrepo.x86_64.rpm
    - source: salt://init/files/kernel-lt-devel-4.4.213-1.el7.elrepo.x86_64.rpm
    - user: root
    - group: root
    - mode: 644

kernel-lt-setup:
  cmd.run:
    - name: cd /usr/local/src && yum localinstall -y kernel-lt-4.4.213-1.el7.elrepo.x86_64.rpm  kernel-lt-devel-4.4.213-1.el7.elrepo.x86_64.rpm && grub2-set-default 0 && reboot
    - unless: cat /boot/grub2/grub.cfg |grep 4.4.213
