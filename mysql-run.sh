#!/bin/sh

sh /mysql-init.sh
chown -R mysql:mysql /var/lib/mysql
mysqld
