scala-21111-install:
  file.managed:
    - name: /usr/local/src/scala-2.11.11.tgz
    - source: salt://modules/files/scala-2.11.11.tgz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /usr/local/src && tar -xvz -f scala-2.11.11.tgz -C /usr/local/ &&  ln -s /usr/local/scala-2.11.11 /usr/local/scala
    - unless: test -d /usr/local/scala-2.11.11 && test -L /usr/local/scala
    - require:
      - file: scala-21111-install 

scala-21111-config:
  file.append:
    - name: /etc/profile
    - text:
      - "#########scala settings########"
      - "SCALA_HOME=/usr/local/scala"
      - "PATH=$PATH:$SCALA_HOME/bin"
      - "export SCALA_HOME PATH"
    - require:
      - file: scala-21111-install
      - cmd: scala-21111-install
