#!/bin/bash
# Connect to PostgreSQL database

set -e

cd "$(dirname "$0")/.."

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-postgres}
POSTGRES_DB=${POSTGRES_DB:-ouranos}

echo "Connecting to PostgreSQL database..."
docker compose exec postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"

