FROM debian:jessie
MAINTAINER Oleg Morozenkov
ENV REFRESHED_AT 2015-08-29

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
	echo "deb http://mirror.mephi.ru/mariadb/repo/10.0/debian jessie main" >> /etc/apt/sources.list && \
	apt-get update && \
	{ \
		echo 'Package: *'; \
		echo 'Pin: release o=MariaDB'; \
		echo 'Pin-Priority: 999'; \
	} > /etc/apt/preferences.d/mariadb && \
	{ \
		echo mariadb-server-$MARIADB_MAJOR mysql-server/root_password password 'unused'; \
		echo mariadb-server-$MARIADB_MAJOR mysql-server/root_password_again password 'unused'; \
	} | debconf-set-selections && \
	apt-get install -y mariadb-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY mysql-entrypoint.sh /mysql-entrypoint.sh
COPY mysql-passwd.sh /mysql-passwd.sh
COPY my.cnf /etc/mysql/my.cnf

VOLUME /var/lib/mysql
EXPOSE 3306
ENTRYPOINT ["sh", "/mysql-entrypoint.sh"]
CMD ["mysqld"]
