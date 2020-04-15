#!/bin/bash
backupday=`date +%Y-%m-%d`
mkdir -p /data/backup/mongo/autoback/$backupday
backdir=/data/backup/mongo/autoback/$backupday
dbname=test
##删除7天前的备份
find $backdir/ -mtime +7 |xargs -i rm -rf {}

###备份数据库
/usr/local/mongodb/bin/mongodump -d $dbname -o $backdir/
