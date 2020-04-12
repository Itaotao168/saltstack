append-javahome2cm-cm:
  file.append:
    - name: /etc/default/cloudera-scm-server
    - text: 
      - "###############cloudera-scm-serverJAVA_HOME#####"
      - "export JAVA_HOME=/usr/local/jdk1.8.0_181"
  cmd.run:
    - name: systemctl restart cloudera-scm-server 

append-javahome2cm-agent:
  file.append:
    - name: /etc/default/cloudera-scm-agent
    - text: 
      - "###############cloudera-scm-agentJAVA_HOME###########"
      - "export JAVA_HOME=/usr/local/jdk1.8.0_181"
  cmd.run:
    - name: systemctl restart cloudera-scm-agent

