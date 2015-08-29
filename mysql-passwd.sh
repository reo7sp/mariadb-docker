#!/bin/sh

if [ -z "$1" -a -z "$2" ]
then
	echo >&2 "Usage: /mysql-passwd.sh USER PASS"
	exit 1
fi

mysqld --skip-grant-tables --skip-networking > /dev/null 2> /dev/null &

echo -n "MariaDB is starting"
i=30
while [ $i -ne 0 ]
do
	echo -n "."
	echo "SELECT 1" | mysql -u root > /dev/null 2> /dev/null
	if [ $? -eq 0 ]
	then
		break
	fi
	sleep 1
	i=$((i-1))
done
echo
if [ "$i" -eq 0 ]
then
	echo >&2 "MariaDB failed to start."
	exit 1
fi

mysql -u root <<-END
	FLUSH PRIVILEGES;
	UPDATE mysql.user SET Password=PASSWORD('${2}') WHERE User='${1}';
	FLUSH PRIVILEGES;
END
