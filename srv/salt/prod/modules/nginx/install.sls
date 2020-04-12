nginx-install:
  pkg.installed:
    - pkgs:
      - gcc 
      - pcre-devel 
      - openssl-devel 
      - zlib-devel 
  archive.extracted:
    - name: /usr/local/src/
    - source: salt://modules/files/nginx-1.12.2.tar.gz
    - source_hash: md5=4d2fc76211435f029271f1cf6d7eeae3
    - archive_format: tar
    - tar_options: v
    - user: root
    - group: root
    - if_missing: /usr/local/src/nginx-1.12.2/
  cmd.run:
    - name: cd /usr/local/src/nginx-1.12.2 && ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-stream && make && make install
    - unless: test -d /usr/local/nginx
    - require: 
      - archive: nginx-install
      - pkg: nginx-install

nginx-running:
  file.managed:
    - name: /usr/lib/systemd/system/nginx.service
    - source: salt://modules/files/nginx.service.template
    - user: root
    - group: root
    - mode: 655
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: nginx-running
    - require:
      - cmd: nginx-install
      - file: nginx-running
