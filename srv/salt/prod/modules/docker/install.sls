docker-files:
  archive.extracted:
    - name: /var/www/html
    - source: salt://modules/files/docker.tar.gz
    - source_hash: md5=dbb7e48f661f5020d0655413e6a2c55a
    - archive_format: tar
    - tar_options: v
    - user: root
    - group: root
    - if_missing: /var/www/html/docker

docker-repo:
  file.managed:
    - name: /etc/yum.repos.d/docker-ce.repo
    - source: salt://modules/files/docker-ce.repo
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: yum clean all &&  yum makecache


docker-install:
  pkg.installed:
    - name: docker-ce
    - onlyif: xfs_info /var/lib/|grep ftype=1
  file.managed:
    - name: /usr/lib/systemd/system/docker.service
    - source: salt://modules/files/docker.service.template
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: echo net.bridge.bridge-nf-call-ip6tables = 1 >>/etc/sysctl.conf && echo net.bridge.bridge-nf-call-iptables = 1 >>/etc/sysctl.conf && echo net.bridge.bridge-nf-call-arptables = 1 >> /etc/sysctl.conf && sysctl -p
    - unless: grep  'net.bridge.bridge-nf-call-ip6tables' /etc/sysctl.conf
  service.running:
    - enable: True
    - name: docker
    - reload: True
    - watch: 
      - file: docker-install

docker-config:
  cmd.run:
    - name: mkdir -p /etc/docker
    - unless: test -d /etc/docker
  file.managed:
    - name: /etc/docker/daemon.json
    - source: salt://modules/files/daemon.json.template
    - user: root
    - group: root
    - mode: 644

docker-other:
  cmd.run:
    - name: docker login -u admin -p Harbor12345  172.16.51.238:1180 && usermod -g ops -G docker ops|echo ok && chmod a+rw /var/run/docker.sock
    - unless: grep  "docker.*ops" /etc/group
