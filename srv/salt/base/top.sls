base:
  '*':
    - init.init-all
prod:
  'web':
    - modules.docker.install
    - modules.nginx.install
    - modules.tomcat.install
    - modules.elasticsearch.install
    - modules.ntpd-server.install
    - modules.pm2.install

  'docker':
    - modules.mongodb.install306
    - modules.mysql.install
    - modules.redis.install
    - modules.ntpd-client.install
