#!/bin/sh

set -e

sh /mysql-init.sh
chown -R mysql:mysql "$DATADIR"
exec "$@"
