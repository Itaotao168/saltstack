{% set ES_VERSION='5.4.3' %}
{% set ES_USER='elastic' %}
include:
  - modules.jdk.install

elasticsearch-install:
  file.managed:
    - name: /usr/local/src/elasticsearch-{{ ES_VERSION }}.tar.gz
    - source: salt://modules/files/elasticsearch-{{ ES_VERSION }}.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: tar xvzf /usr/local/src/elasticsearch-{{ ES_VERSION }}.tar.gz -C /usr/local/ && groupadd {{ ES_USER }}|echo ok && useradd -s /sbin/nologin -M -g {{ ES_USER }} {{ ES_USER }} |echo ok && ln -s /usr/local/elasticsearch-{{ ES_VERSION }} /usr/local/elasticsearch|echo ok && chown -R {{ ES_USER }}.{{ ES_USER }} /usr/local/elasticsearch && chown -R {{ ES_USER }}.{{ ES_USER }} /usr/local/elasticsearch-{{ ES_VERSION }}
    - unless: test -d /usr/local/elasticsearch-{{ ES_VERSION }} && test -L /usr/local/elasticsearch
    - require:
      - file: elasticsearch-install

elasticsearch-ik-install:
  file.managed:
    - name: /usr/local/src/analysis-ik.tar.gz
    - source: salt://modules/files/analysis-ik.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: tar -xvz -f /usr/local/src/analysis-ik.tar.gz -C /usr/local/elasticsearch-{{ ES_VERSION }}/ && chown -R {{ ES_USER }}.{{ ES_USER }} /usr/local/elasticsearch     && chown -R {{ ES_USER }}.{{ ES_USER }} /usr/local/elasticsearch-{{ ES_VERSION }}
    - unless: test -d /usr/local/elasticsearch-{{ ES_VERSION }}/plugins/analysis-ik/
    - require:
      - cmd: elasticsearch-install

vm.max_map_count:
  sysctl.present:
    - value: 655360

elasticsearch-config:
  file.managed:
    - name: /usr/local/elasticsearch/config/elasticsearch.yml
    - source: salt://modules/files/elasticsearch.yml.template
    - user: {{ ES_USER }}
    - group: {{ ES_USER }}
    - mode: 644
    - template: jinja
    - defaults:
      IPADDR: {{ grains['fqdn']}}
      PORT: 9200
      NODE_NAME: {{ grains['fqdn']}}

elasticsearch-jvm:
  file.managed:
    - name: /usr/local/elasticsearch/config/jvm.options
    - source: salt://modules/files/jvm.options.template
    - user: {{ ES_USER }}
    - group: {{ ES_USER }}
    - mode: 644

elasticsearch-env:
  file.managed:
    - name: /usr/local/elasticsearch/elasenv
    - source: salt://modules/files/elasenv.template
    - user: {{ ES_USER }}
    - group: {{ ES_USER }}
    - mode: 644

elasticsearch-service:
  file.managed:
    - name: /usr/lib/systemd/system/elasticsearch.service
    - source: salt://modules/files/elasticsearch.service.template
    - user: {{ ES_USER }}
    - group: {{ ES_USER }}
    - template: jinja
    - defaults:
      ELAS_USER: {{ ES_USER }}
    - mode: 644
  service.running:
    - enable: True
    - name: elasticsearch
    - reload: True
    - watch: 
      - file: elasticsearch-service
      - file: elasticsearch-config
    - require:
      - file: elasticsearch-service 
      - file: elasticsearch-env
      - file: elasticsearch-config
      - cmd: elasticsearch-install
