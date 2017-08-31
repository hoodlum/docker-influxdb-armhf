#!/bin/sh
set -e

echo "=> Run container usings args: $@" 

if [ -z "$1" ]; then
    set -- influxd
fi

exec "$@"
