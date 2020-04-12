local-repo-file:
  file.managed:
    - name: /etc/yum.repos.d/CentOS-Base.repo
    - source: salt://init/files/CentOS-Base-http.repo
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: yum clean all && yum makecache  
    - unless: grep 192.168.10.4 /etc/yum.repos.d/CentOS-Base.repo
