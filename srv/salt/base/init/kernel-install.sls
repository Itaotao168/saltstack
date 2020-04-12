kernel-install:
  cmd.run:
    - name: yum --enablerepo=elrepo-kernel install  kernel-ml-devel kernel-ml -y && grub2-set-default 0 && reboot
