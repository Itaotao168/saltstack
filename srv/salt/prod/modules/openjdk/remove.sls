openjdk-uninstall:
  pkg.removed:
    - name: java-1.8.0-openjdk
    - version: 1:1.8.0.222.b03-1.el7 
  cmd.run:
    - name: rm -rf /usr/bin/java
    - onlyif: test -L /usr/bin/java

