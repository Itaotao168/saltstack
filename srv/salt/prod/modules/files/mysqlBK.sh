#!/bin/bash
# Databases that you wish to be backed up by this script. You can have any number of databases specified; encapsilate each database name in single quotes and separate each database name by a space.
#
# Example:
# databases=('__DATABASE_1__' '__DATABASE_2__')
#databases=('gzurbsp' 'gncm')
databases=('sys')

# The host name of the MySQL database server; usually 'localhost'
db_host="localhost"

# The port number of the MySQL database server; usually '3306'
db_port="3306"

# The MySQL user to use when performing the database backup.
db_user="root"

# The password for the above MySQL user.
db_pass="!#ImapIlbs-123"

# Directory to which backup files will be written. Should end with slash ("/").
backups_dir="/data/backup/"

if [ ! -d $backups_dir ]; then
  mkdir -p $backups_dir
fi


backups_user="ops"

# Date/time included in the file names of the database backup files.
datetime=$(date +'%Y-%m-%d-%H:%M:%S')

#Delete 7 days before backing up data
find $backups_dir -mtime +7 -name "*.gz" -print0 |xargs -0 -i rm -f {}

for db_name in ${databases[@]}; do
        # Create database backup and compress using gzip.
        /usr/local/mysql/bin/mysqldump -u $db_user -h $db_host -P $db_port --password=$db_pass $db_name | gzip -9 > $backups_dir$db_name-$datetime.sql.gz
done

# Set appropriate file permissions/owner.
chown $backups_user:$backups_user $backups_dir*-$datetime.sql.gz
chmod 0400 $backups_dir*-$datetime.sql.gz
