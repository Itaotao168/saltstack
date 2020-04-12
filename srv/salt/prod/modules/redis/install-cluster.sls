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

redis-config-6379:
  file.managed:
    - name: /usr/local/redis/conf/redis_6379.conf
    - source: salt://modules/files/redis_6379.conf.template
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      REDIS_PORT: 6379

redis-config-6380:
  file.managed:
    - name: /usr/local/redis/conf/redis_6380.conf
    - source: salt://modules/files/redis_6379.conf.template
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      REDIS_PORT: 6380



redis-cluster-service:
  file.managed:
    - name: /usr/local/redis/bin/start-all.sh
    - source: salt://modules/files/start-all.sh
    - user: root
    - group: root
    - mode: 744
  cmd.run:
    - name: /usr/local/redis/bin/start-all.sh
    - unless: ps -aux|grep redis-server|grep -v grep

redis-cluster-enabled:
  file.append:
    - name: /etc/rc.d/rc.local
    - text:
      - '#begin to process'
      - 'exec 2> /tmp/rc.local.log'
      - 'exec 1>&2'
      - 'echo rc.local started'
      - 'touch /var/lock/subsys/local'
      - 'cd /usr/local/redis/conf'
      - '/usr/local/redis/bin/start-all.sh'
  cmd.run:
    - name: chmod u+x /etc/rc.d/rc.local 
    - unless: test -x /etc/rc.d/rc.local
