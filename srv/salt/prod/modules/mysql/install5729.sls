{% set MY_USER='mysql' %}
{% set MYSQL_PATH='/data/mysql' %}
{% set MYSQL_VERSION='mysql-5.7.29-linux-glibc2.12-x86_64' %}
mysql-install:
  pkg.installed:
    - pkgs:
      - libaio
  file.managed:
    - name: /usr/local/src/{{ MYSQL_VERSION }}.tar.gz
    - source: salt://modules/files/{{ MYSQL_VERSION }}.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: groupadd {{ MY_USER }} | echo ok && useradd -g {{ MY_USER }} -s /bin/bash {{ MY_USER }} |echo ok && tar -xvz -f  /usr/local/src/{{ MYSQL_VERSION }}.tar.gz -C /usr/local/ |echo ok && ln -s /usr/local/{{ MYSQL_VERSION }} /usr/local/mysql | echo ok && ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql |echo ok && chown -R {{ MY_USER }}.{{ MY_USER }} /usr/local/mysql /usr/local/{{ MYSQL_VERSION }}
    - unless: test -L /usr/local/mysql  && test -d /usr/local/{{ MYSQL_VERSION }}
    - require: 
      - file: mysql-install

mysql-config:
  cmd.run:
    - name: mkdir -p {{ MYSQL_PATH }}/{data,binlogs,log} &&  chown -R {{ MY_USER }}.{{ MY_USER }}     {{ MYSQL_PATH }}/
    - unless: test `ls -A  {{ MYSQL_PATH }}/data |wc -w` -gt 0
  file.managed:
    - name: /etc/my.cnf
    - source: salt://modules/files/my.cnf.template
    - user: root
    - group: root
    - mode: 655
    - template: jinja
    - defaults: 
      MYSQL_PATH: {{ MYSQL_PATH }}


mysql-init:
  cmd.run:
    - name: runuser -l {{ MY_USER }} -c '/usr/local/mysql/bin/mysqld --initialize-insecure --user=mysql  --basedir=/usr/local/mysql --datadir={{ MYSQL_PATH }}/data' && runuser -l {{ MY_USER }} -c  '/usr/local/mysql/bin/mysql_ssl_rsa_setup --basedir=/usr/local/mysql --datadir={{ MYSQL_PATH }}/data'
    - unless: test `ls -A  {{ MYSQL_PATH }}/data |wc -w` -gt 0
    - require:
      - cmd: mysql-install
      - cmd: mysql-config 

mysql-service:
  file.managed:
    - name: /usr/lib/systemd/system/mysqld.service
    - source: salt://modules/files/mysqld.service.template
    - user: root
    - group: root
    - mode: 655
    - template: jinja
    - defaults: 
      MySQL_USER: {{ MY_USER }}
  service.running:
    - enable: True
    - reload: True
    - name: mysqld
    - watch:
      - file: mysql-service
    - require:
      - file: mysql-config
      - cmd: mysql-init
      - file: mysql-service

mysql-passwd:
  cmd.run:
    - name: mysql -e "use mysql;update user set authentication_string=password('!#ImapIlbs-123') where user='root' and Host ='localhost';GRANT ALL PRIVILEGES ON *.* TO root@'%'  IDENTIFIED BY '!#ImapIlbs-123';flush privileges;"
    - onlyif: mysql -e "show variables like '%char%';"
    - require:
      - service: mysql-service
