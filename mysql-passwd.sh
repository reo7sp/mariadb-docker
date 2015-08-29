#!/bin/sh

if [ -z "$1" -a -z "$2" ]
then
	echo >&2 "Usage: /mysql-passwd.sh USER PASS"
	exit 1
fi

mysqld --skip-grant-tables --skip-networking &
mysql -u root <<-END
	FLUSH PRIVILEGES;
	SET PASSWORD FOR '${1}'@'localhost' = PASSWORD('${2}');
	FLUSH PRIVILEGES;
END
