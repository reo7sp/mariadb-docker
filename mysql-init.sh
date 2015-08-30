#!/bin/sh

set -e

DATADIR=/var/lib/mysql

if [ ! -d "$DATADIR/mysql" ]
then
	mkdir -p "$DATADIR"
	chown -R mysql:mysql "$DATADIR"
	echo "Initializing mysql."
	mysql_install_db --user=mysql --datadir="$DATADIR"
	echo "Done."

	for f in /mysql-init.d/*
	do
		echo "Running mysql init script $f"
		sh "$f"
	done
fi

