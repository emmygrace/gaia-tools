#!/bin/bash
# Start development environment
# 
# This script starts all services in development mode with hot reload.
# For a fresh start (reset database), use: ./docker/fresh-start.sh
# To reset just the database: ./docker/reset-db.sh

set -e

cd "$(dirname "$0")/.."

echo "Starting Ouranos development environment..."

# Check if .env exists, create from example if not
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        echo "Creating .env from .env.example..."
        cp .env.example .env
    else
        echo "Warning: .env.example not found. You may need to create .env manually."
    fi
fi

docker compose up --build

