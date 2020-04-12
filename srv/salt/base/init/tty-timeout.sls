tty_timeout:
  file.append:
    - name: /etc/profile
    - source: salt://init/files/profile.template
    - user: root
    - group: root
    
