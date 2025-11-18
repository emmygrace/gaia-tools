#!/bin/bash
# Reset database (drop volumes, recreate)
#
# This script stops services, removes the postgres volume, and restarts services.
# The database will be recreated and migrations will run automatically on startup.
#
# WARNING: This will delete all database data!

set -e

cd "$(dirname "$0")/.."

echo "WARNING: This will delete all database data!"
echo "Press Ctrl+C to cancel, or Enter to continue..."
read -r

echo "Stopping services..."
docker compose down

echo "Removing postgres volume..."
# Remove the postgres volume (Docker Compose prefixes with project name)
docker volume rm gaia-tools_postgres_data 2>/dev/null || \
docker volume ls -q | grep postgres_data | xargs -r docker volume rm || \
echo "Volume already removed or doesn't exist"

echo "Starting services (database will be recreated)..."
docker compose up -d postgres

echo "Waiting for PostgreSQL to be ready..."
sleep 5

echo "Starting backend (migrations will run automatically)..."
docker compose up -d coeus-api-backend

echo ""
echo "Database reset complete!"
echo "Services are starting. Check status with: ./docker/logs.sh"

