#!/bin/sh

set -e

chown -R mysql:mysql /var/lib/mysql

exec "$@"
