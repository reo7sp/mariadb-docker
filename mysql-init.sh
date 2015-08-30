#!/bin/sh

if [ ! -d "$DATADIR/mysql" ]
then
	mkdir -p "/var/lib/mysql"
	chown -R mysql:mysql "/var/lib/mysql"
	echo "Initializing mysql."
	mysql_install_db --user=mysql --datadir="/var/lib/mysql"
	echo "Done."

	if [ -d "/mysql-init.d" ]
	then
		for f in $(find /mysql-init.d/ -type f)
		do
			echo "Running mysql init script $f"
			sh "$f"
		done
	fi
fi

