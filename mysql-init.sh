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
fi

