#!/bin/sh

set -e

if [ ! -d "$DATADIR/mysql" ]
then
	mkdir -p "/var/lib/mysql"
	chown -R mysql:mysql "/var/lib/mysql"
	echo "Initializing mysql."
	mysql_install_db --user=mysql --datadir="/var/lib/mysql"
	echo "Done."

	if [ -d "/mysql-init.d" ]
	then
		for f in /mysql-init.d/*
		do
			echo "Running mysql init script $f"
			sh "$f"
		done
	fi
fi

