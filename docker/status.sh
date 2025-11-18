#!/bin/bash
# Check status of Docker services

set -e

cd "$(dirname "$0")/.."

echo "=== Docker Services Status ==="
echo ""

# Check if docker compose is running
if ! docker compose ps > /dev/null 2>&1; then
    echo "Docker Compose is not available or services are not running."
    exit 1
fi

# Show service status
docker compose ps

echo ""
echo "=== Service Health ==="
echo ""

# Check backend
echo "Backend (FastAPI):"
if docker compose ps coeus-api-backend | grep -q "Up"; then
    if curl -s http://127.0.0.1:8000/ > /dev/null 2>&1; then
        echo "  ✓ Running on http://127.0.0.1:8000"
        echo "  ✓ API Docs: http://127.0.0.1:8000/docs"
    else
        echo "  ⚠ Container running but not responding"
    fi
else
    echo "  ✗ Not running"
fi

echo ""

# Check postgres
echo "PostgreSQL:"
if docker compose ps postgres | grep -q "Up"; then
    if docker compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; then
        echo "  ✓ Running and ready"
    else
        echo "  ⚠ Container running but not ready"
    fi
else
    echo "  ✗ Not running"
fi

echo ""
echo "=== Access URLs ==="
echo "Backend API: http://localhost:8000"
echo "API Docs: http://localhost:8000/docs"
echo ""
echo "View logs: ./docker/logs.sh [service]"

