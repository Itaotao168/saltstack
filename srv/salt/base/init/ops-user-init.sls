ops-init:
  group.present:
    - name: ops
    - gid: 1002
  user.present:
    - name: ops2
    - fullname: ops2
    - shell: /bin/bash
    - home: /home/ops2
    - uid: 1003
    - gid: 1002
