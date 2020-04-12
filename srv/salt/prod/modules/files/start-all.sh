#! /bin/bash
nohup /usr/local/redis/bin/redis-server /usr/local/redis/conf/redis_6379.conf &
nohup /usr/local/redis/bin/redis-server /usr/local/redis/conf/redis_6380.conf &
