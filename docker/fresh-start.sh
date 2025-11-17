#!/bin/bash
# Complete fresh start: stop everything, remove volumes, rebuild, start
#
# This script performs a complete reset:
# - Stops all services
# - Removes all volumes (database data, node_modules cache, etc.)
# - Removes all containers
# - Rebuilds all images
# - Starts services fresh
#
# WARNING: This will delete all data including database, caches, and volumes!

set -e

cd "$(dirname "$0")/.."

echo "=========================================="
echo "  FRESH START - Complete Reset"
echo "=========================================="
echo ""
echo "WARNING: This will delete:"
echo "  - All database data"
echo "  - All Docker volumes"
echo "  - All containers"
echo "  - All cached data"
echo ""
echo "Press Ctrl+C to cancel, or Enter to continue..."
read -r

echo ""
echo "Stopping all services..."
docker compose down -v

echo "Removing all containers..."
docker compose rm -f 2>/dev/null || true

echo "Removing all volumes..."
docker volume ls -q | grep ouranos | xargs -r docker volume rm || true

echo "Pruning unused Docker resources..."
docker system prune -f

echo ""
echo "Rebuilding and starting services..."
docker compose up --build -d

echo ""
echo "Waiting for services to start..."
sleep 5

echo ""
echo "=========================================="
echo "  Fresh start complete!"
echo "=========================================="
echo ""
echo "Services are starting. Check status with:"
echo "  ./docker/logs.sh"
echo ""
echo "Or view logs for a specific service:"
echo "  ./docker/logs.sh backend"
echo "  ./docker/logs.sh nextjs"
echo "  ./docker/logs.sh postgres"
echo ""

