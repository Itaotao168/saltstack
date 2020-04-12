pv_create:
  lvm.pv_present:
    - name: /dev/sda

vgs_mg:
  lvm.vg_present:
    - name: centos
    - devices:
       - /dev/sda
       - /dev/vda2

lv_create:
  lvm.lv_present:
    - name: data
    - vgname: centos 
    - size: 3600G

/data:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

mount_create:
  file.append:
    - name: /etc/fstab
    - text: /dev/mapper/centos-data  /data  xfs     defaults        0 0
  cmd.run:
    - name: mkfs.xfs /dev/mapper/centos-data && mount -a 
    - unless: df -hT |grep data
