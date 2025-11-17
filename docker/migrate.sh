#!/bin/bash
# Run database migrations manually

set -e

cd "$(dirname "$0")/.."

echo "Running database migrations..."

docker compose exec backend alembic upgrade head

echo "Migrations completed."

