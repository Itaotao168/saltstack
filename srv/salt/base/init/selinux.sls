/etc/selinux/config:
  file.managed:
    - source: salt://init/files/selinux.template
    - user: root
    - group: root
    - mode: 644
  cmd.run:
{% if grains['selinux'] == 'True' %}
    - name: echo True
{% else %}
    - name: echo Goodbye
{% endif %}

  
