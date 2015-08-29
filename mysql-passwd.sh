#!/bin/sh

if [ -z "$1" -a -z "$2" ]
then
	echo >&2 "Usage: /mysql-passwd.sh USER PASS"
	exit 1
fi

mysqld --skip-grant-tables --skip-networking &

for i in {30..0}; do
	if echo 'SELECT 1' | mysql -u root &> /dev/null; then
		break
	fi
	sleep 1
done
if [ "$i" = 0 ]; then
	echo >&2 "MySQL init process failed."
	exit 1
fi

mysql -u root <<-END
	FLUSH PRIVILEGES;
	SET PASSWORD FOR '${1}'@'localhost' = PASSWORD('${2}');
	FLUSH PRIVILEGES;
END
