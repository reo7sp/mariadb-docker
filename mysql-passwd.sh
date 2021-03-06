#!/bin/sh

if [ -z "$1" -a -z "$2" ]
then
	echo >&2 "Usage: /mysql-passwd.sh USER PASS"
	exit 1
fi

mysqld --skip-grant-tables --skip-networking &
pid="$!"

echo ":: MySQL daemon is starting..."
i=30
while [ $i -ne 0 ]
do
	echo "SELECT 1" | mysql -uroot
	if [ $? -eq 0 ]
	then
		break
	fi
	sleep 1
	i=$((i-1))
done
if [ "$i" -eq 0 ]
then
	echo >&2 ":: MySQL daemon failed to start"
	exit 1
fi
echo ":: MySQL daemon has been started"

echo ":: Changing password of $1"
mysql -u root <<-END
	FLUSH PRIVILEGES;
	UPDATE mysql.user SET Password=PASSWORD('${2}') WHERE User='${1}';
	FLUSH PRIVILEGES;
END
echo ":: Done"

echo ":: Stopping MySQL daemon"
if ! kill -s TERM "$pid" || ! wait "$pid"
then
	echo >&2 ":: MySQL can't be stopped"
else
	echo ":: Done"
fi

echo ":: Everything is done"
