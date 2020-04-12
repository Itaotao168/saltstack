sysstat-install:
  archive.extracted:
    - name: /usr/local/
    - source: salt://modules/files/sysstat-12.3.1.tar.gz
    - source_hash: md5=64dfc53d4178b98fe75c8ab1ddcef98b
    - archive_format: tar
    - tar_options: v
    - user: root
    - group: root
    - if_missing: /usr/local/sysstat-12.3.1
  pkg.installed:
    - pkgs:
      - gcc
  cmd.run:
    - name: cd /usr/local/sysstat-12.3.1 && ./configure --enable-install-cron --prefix=/usr/local/sysstat &&  make && make  install  && rm -rf /usr/local/sysstat-12.3.1
    - unless: test -d /usr/local/sysstat
    - require:
      - archive: sysstat-install
  file.append:
    - name: /etc/profile
    - text:
      - "####sysstat settings####"
      - "PATH=$PATH:/usr/local/sysstat/bin"
      - "export PATH"
    - require:
      - archive: sysstat-install
      - pkg: sysstat-install
      - cmd: sysstat-install
