#!/bin/bash
egrep -oR  '[0-9]{2,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|[0-9]{2,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\:[0-9]{1,6}' --exclude-dir=.svn $1  >/tmp/webapp.txt 2>/dev/null
grep -v 'Binary' /tmp/webapp.txt >/tmp/webapp-1.txt
egrep -oR  '[0-9]{2,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|[0-9]{2,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\:[0-9]{1,6}' /tmp/webapp-1.txt  >/tmp/webapp-2.txt
awk '!a[$0]++' /tmp/webapp-2.txt >/tmp/webapp-3.txt
sort -k1 /tmp/webapp-3.txt -o /tmp/webapp-3.txt
