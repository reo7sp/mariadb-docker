#!/bin/sh

set -e

sh /mysql-init.sh
chown -R mysql:mysql /var/lib/mysql
mysql_upgrade
mysqld
