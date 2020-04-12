{% set TOMCAT_VERSION='8.5.33' %}
{% set TOMCAT_USER='tomcat' %}
include:
  - modules.jdk.install

tomcat-install:
  file.managed:
    - name: /usr/local/src/apache-tomcat-{{ TOMCAT_VERSION }}.tar.gz
    - source: salt://modules/files/apache-tomcat-{{ TOMCAT_VERSION }}.tar.gz
    - user: root
    - group: root
    - mode: 644

  cmd.run:
    - name: cd /usr/local/src && tar -xvz -f apache-tomcat-{{ TOMCAT_VERSION }}.tar.gz -C /usr/local/ && ln -s /usr/local/apache-tomcat-{{ TOMCAT_VERSION }} /usr/local/tomcat
    - unless: test -d /usr/local/apache-tomcat-{{ TOMCAT_VERSION }} && test -L /usr/local/tomcat
    - require: 
      - file: jdk-8u181-install
      - cmd: jdk-8u181-install
      - file: tomcat-install

tomcat-config:
  file.append:
    - name: /etc/profile
    - text:
      - "##########tomcat env setting#############"
      - "export TOMCAT_HOME=/usr/local/tomcat"
      - "export CATALINA_HOME=/usr/local/tomcat"
      - "export CATALINA_BASE=/usr/local/tomcat"

tomcat-setenv-config:
  cmd.run:
    - name: touch /usr/local/tomcat/tomcat.pid
    - unless: test -e /usr/local/tomcat/tomcat.pid
  file.managed:
    - name: /usr/local/tomcat/bin/setenv.sh
    - source: salt://modules/files/setenv.sh.template
    - user: root
    - group: root
    - mode: 755
    - require:
      - cmd: tomcat-setenv-config

tomcat-startup-config:
  file.managed:
    - name: /usr/local/tomcat/bin/startup.sh
    - source: salt://modules/files/startup.sh.template
    - user: root
    - group: root
    - mode: 755

tomcat-systemd-config:
  file.managed:
    - name: /usr/lib/systemd/system/tomcat.service
    - source: salt://modules/files/tomcat.service.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      TM_USER: {{ TOMCAT_USER }}

tomcat-service-config:
  cmd.run:
    - name: useradd -s /sbin/nologin {{ TOMCAT_USER  }}|echo ok && chown -R {{ TOMCAT_USER  }}.{{ TOMCAT_USER  }} /usr/local/tomcat /usr/local/apache-tomcat-{{ TOMCAT_VERSION }}
    - unless: grep {{ TOMCAT_USER  }} /etc/passwd
  service.running:
    - name: tomcat
    - enable: True
    - reload: True
    - require:
      - cmd: tomcat-install
      - file: tomcat-config
      - file: tomcat-setenv-config
      - file: tomcat-startup-config
      - file: tomcat-systemd-config
    - watch:
      - file: tomcat-systemd-config
