#!/bin/bash
# View logs from all services

set -e

cd "$(dirname "$0")/.."

# If service name provided, show logs for that service only
if [ -n "$1" ]; then
    docker compose logs -f "$1"
else
    docker compose logs -f
fi

