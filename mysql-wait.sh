#!/bin/sh

echo -n "mysql is starting"
i=30
while [ $i -ne 0 ]
do
	echo -n "."
	echo "SELECT 1" | mysql -u root > /dev/null 2> /dev/null
	if [ $? -eq 0 ]
	then
		exit 0
	fi
	sleep 1
	i=$((i-1))
done
echo
if [ "$i" -eq 0 ]
then
	echo >&2 "mysql failed to start."
	exit 1
fi
