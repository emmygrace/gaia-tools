#!/bin/bash
# Stop all services
#
# Usage:
#   ./down.sh          - Stop services (keep volumes)
#   ./down.sh --volumes - Stop services and remove volumes (fresh start)
#   ./down.sh -v       - Same as --volumes

set -e

cd "$(dirname "$0")/.."

if [ "$1" = "--volumes" ] || [ "$1" = "-v" ]; then
    echo "Stopping Gaia Tools services and removing volumes..."
    docker compose down -v
    echo "Services stopped and volumes removed."
else
    echo "Stopping Gaia Tools services..."
    docker compose down
    echo "Services stopped."
fi

