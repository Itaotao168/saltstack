tty-init:
  file.append:
    - name: /etc/bashrc
    - text:
      - export TMOUT=4000
      - export PS1='[\u@\h \w]\$ '
