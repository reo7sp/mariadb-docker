#!/bin/sh

if [ -z "$1" -a -z "$2" ]
then
	echo >&2 "Usage: /mysql-passwd.sh USER PASS"
	exit 1
fi

mysqld --skip-grant-tables --skip-networking &

echo -n "MariaDB is starting."
for i in {30..0}; do
	if echo "SELECT 1" | mysql -u root
	then
		break
	fi
	echo -n "."
	sleep 1
done
echo
if [ "$i" -eq 0 ]
then
	echo >&2 "MariaDB failed to start."
	exit 1
fi

mysql -u root <<-END
	FLUSH PRIVILEGES;
	SET PASSWORD FOR '${1}'@'localhost' = PASSWORD('${2}');
	FLUSH PRIVILEGES;
END
