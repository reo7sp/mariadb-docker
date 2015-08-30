#!/bin/sh

if [ -z "$1" -a -z "$2" ]
then
	echo >&2 "Usage: /mysql-passwd.sh USER PASS"
	exit 1
fi

mysqld --skip-grant-tables --skip-networking > /dev/null 2> /dev/null &

sh /mysql-wait.sh

mysql -u root <<-END
	FLUSH PRIVILEGES;
	UPDATE mysql.user SET Password=PASSWORD('${2}') WHERE User='${1}';
	FLUSH PRIVILEGES;
END

kill /var/run/mysqld/mysqld.pid
