stress-ng-install:
  archive.extracted:
    - name: /usr/local/
    - source: salt://modules/files/stress-ng-0.11.07.tar.xz
    - source_hash: md5=d492e7955ca047ff748ce74cea4a6c76
    - archive_format: tar
    - tar_options: J
    - user: root
    - group: root
    - if_missing: /usr/local/stress-ng-0.11.07
  pkg.installed:
    - pkgs:
      - gcc
  cmd.run:
    - name: cd /usr/local/stress-ng-0.11.07 && make && make  install  && rm -rf /usr/local/stress-ng-0.11.07
    - unless: test -d /usr/local/stress-ng
    - require:
      - archive: stress-ng-install
