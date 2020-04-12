jdk-8u181-install:
  file.managed:
    - name: /usr/local/src/jdk-8u181-linux-x64.tar.gz
    - source: salt://modules/files/jdk-8u181-linux-x64.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /usr/local/src && tar -xvz -f jdk-8u181-linux-x64.tar.gz -C /usr/local/ &&  ln -s /usr/local/jdk1.8.0_181 /usr/local/jdk
    - source: salt://modules/files/jdk-8u181-linux-x64.tar.gz
    - unless: test -d /usr/local/jdk1.8.0_181 && test -L /usr/local/jdk
    - require:
      - file: jdk-8u181-install 

jdk-8u181-config:
  file.append:
    - name: /etc/profile
    - text:
      - "#########JDK settings########"
      - "JAVA_HOME=/usr/local/jdk1.8.0_181"
      - "JRE_HOME=$JAVA_HOME/jre"
      - "PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin"
      - "CLASSPATH=:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib"
      - "export JAVA_HOME JRE_HOME PATH CLASSPATH"
    - require:
      - file: jdk-8u181-install
      - cmd: jdk-8u181-install
