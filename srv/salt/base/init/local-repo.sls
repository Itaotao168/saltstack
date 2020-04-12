eocal-repo-file:
  file.managed:
    - name: /etc/yum.repos.d/CentOS-Base.repo
    - source: salt://init/files/CentOS-Base.repo
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: yum clean all && yum makecache  
