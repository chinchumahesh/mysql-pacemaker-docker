#!/bin/sh

# Check if HAProxy is running
if ! pgrep -x "haproxy" >/dev/null; then
  exit 1
fi

# Check if ports are listening
if ! nc -z localhost 3306 || ! nc -z localhost 3307; then
  exit 1
fi

exit 0