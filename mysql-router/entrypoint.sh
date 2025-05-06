#!/bin/sh
set -e

# Wait for primary MySQL to be ready
while ! nc -z ${MYSQL_HOST} ${MYSQL_PORT}; do
  echo "Waiting for MySQL at ${MYSQL_HOST}:${MYSQL_PORT}..."
  sleep 2
done

# Bootstrap metadata if needed (for InnoDB Cluster)
if [ ! -f /var/lib/mysqlrouter/metadata.json ]; then
  echo "Bootstrapping MySQL Router..."
  mysqlrouter --bootstrap ${MYSQL_USER}:${MYSQL_PASSWORD}@${MYSQL_HOST}:${MYSQL_PORT} \
    --user=mysqlrouter \
    --directory=/var/lib/mysqlrouter \
    --force
fi

# Start MySQL Router
exec "$@"