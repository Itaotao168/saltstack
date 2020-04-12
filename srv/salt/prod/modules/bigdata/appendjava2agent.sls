append-javahome2agent-agent:
  file.append:
    - name: /etc/default/cloudera-scm-agent
    - text: 
      - "###############modify cloudera-scm-agent JAVA_HOME"
      - "export JAVA_HOME=/usr/local/jdk1.8.0_181"
  cmd.run:
    - name: systemctl restart cloudera-scm-agent

