{% set REDIS_VERSION='5.0.4' %}
vm.overcommit_memory:
  sysctl.present:
    - value: 1

redis-installed:
  archive.extracted:
    - name: /usr/local/src/
    - source: salt://modules/files/redis-{{ REDIS_VERSION }}.tar.gz
    - user: root
    - group: root
    - archive_format: tar
    - tar_options: v 
    - if_missing: /usr/local/src/redis-{{ REDIS_VERSION }}
    - unless: test -d /usr/local/src/redis-{{ REDIS_VERSION }}

  pkg.installed:
    - pkgs:
      - gcc
      - tcl
      - gcc-c++
  cmd.run:
    - name: cd /usr/local/src/redis-{{ REDIS_VERSION }} && make MALLOC=libc && make PREFIX=/usr/local/redis install && ln -s /usr/local/redis/bin/redis-cli /usr/bin/redis-cli |echo ok
    - require:
      - pkg: redis-installed
      - archive: redis-installed
    - unless: test -L /usr/bin/redis-cli && test -d /usr/local/redis

redis-startup-config:
  file.managed:
    - name: /usr/local/redis/conf/redis_6379.conf
    - source: salt://modules/files/redis.conf.template
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      REDIS_PORT: 6379

redis-systemd-config:
  file.managed:
    - name: /usr/lib/systemd/system/redisd.service
    - source: salt://modules/files/redisd.service.template
    - user: root
    - group: root
    - mode: 644

redis-service-config:
  service.running:
    - name: redisd
    - enable: True
    - reload: True
