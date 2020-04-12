sysbench-install:
  archive.extracted:
    - name: /usr/local/
    - source: salt://modules/files/sysbench.tar.gz
    - source_hash: md5=67aaf85146eda67216ae45221bba06ec
    - archive_format: tar
    - tar_options: v
    - user: root
    - group: root
    - if_missing: /usr/local/sysbench
  pkg.installed:
    - pkgs:
      - make
      - automake 
      - libtool
      - pkgconfig
      - libaio-devel
      - mariadb-devel
      - openssl-devel
      - postgresql-devel
  cmd.run:
    - name: cd /usr/local/sysbench && ./autogen.sh && ./configure --with-pgsql && make -j && make  install  && rm -rf /usr/local/sysbench
    - unless: test -f /usr/local/bin/sysbench
    - require:
      - archive: sysbench-install
