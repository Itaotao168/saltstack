transparent_hugepage-config:
  cmd.run:
    - name: sed -i  's/quiet/& transparent_hugepage=never/g'  /etc/default/grub
    - unless: grep 'transparent_hugepage' /etc/default/grub 

transparent_hugepage-config2:
  cmd.run:
    - name: grub2-mkconfig -o /boot/grub2/grub.cfg && reboot
    - onlyif: cat /sys/kernel/mm/transparent_hugepage/enabled|grep '\[always\]'
