#!/bin/sh

cd /

if [ ! -d "/var/lib/mysql/mysql" ]
then
	echo ":: Initializing MySQL..."

	# initial setup
	mkdir -p "/var/lib/mysql"
	chown -R mysql:mysql "/var/lib/mysql"
	mysql_install_db --user=mysql --datadir="/var/lib/mysql"

	# starting mysql daemon
	mysqld --skip-grant-tables --skip-networking &
	pid="$!"

	# wait for mysql daemon to start
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

	# doing some mysql setup
	echo ":: Doing MySQL setup"
	if [ -f "/mysql-init.d/rootpw.txt" ]
	then
		mysql_rootpw=$(cat "/mysql-init.d/rootpw.txt" | sed "s/\n//g; s/\r//g")
	else
		echo >&2 ":: /mysql-init.d/rootpw.txt can't be found. Setting MySQL root password to \"unset\""
		mysql_rootpw=unset
	fi
	mysql -uroot <<-END
		SET @@SESSION.SQL_LOG_BIN=0;
		FLUSH PRIVILEGES;
		DELETE FROM mysql.user;
		FLUSH PRIVILEGES;
		CREATE USER 'root'@'%' IDENTIFIED BY '${mysql_rootpw}';
		GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
		DROP DATABASE IF EXISTS test;
		FLUSH PRIVILEGES;
	END
	echo ":: Done"

	# running user scripts
	if [ -d "/mysql-init.d" ]
	then
		echo ":: Running user scripts"
		for f in $(find /mysql-init.d -type f)
		do
			case "$f" in
				*.sh)  echo ":: Running script $f"; sh "$f" ;;
				*.sql) echo ":: Running sql file $f"; mysql -uroot -p$mysql_rootpw < "$f" ;;
				*)     ;;
			esac
		done
		echo ":: Done"
	fi

	# stopping mysql daemon
	echo ":: Stopping MySQL daemon"
	if ! kill -s TERM "$pid" || ! wait "$pid"
	then
		echo >&2 ":: MySQL can't be stopped"
	else
		echo ":: Done"
	fi

	echo ":: Everything is done"
fi

chown -R mysql:mysql /var/lib/mysql
mysqld
