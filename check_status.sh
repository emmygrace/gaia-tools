#!/bin/bash
# Check status of backend and frontend servers
# 
# This script checks for locally running services (not in Docker).
# For Docker services, use: ./docker/status.sh

echo "=== Server Status Check (Local Services) ==="
echo ""
echo "Note: For Docker services, use: ./docker/status.sh"
echo ""

# Check backend
echo "Backend (FastAPI):"
if curl -s http://127.0.0.1:8000/ > /dev/null 2>&1; then
    echo "  ✓ Running on http://127.0.0.1:8000"
    curl -s http://127.0.0.1:8000/ | python3 -m json.tool 2>/dev/null || echo "    Response received"
    echo "  ✓ API Docs: http://127.0.0.1:8000/docs"
else
    echo "  ✗ Not running"
    echo "    (If using Docker, check with: ./docker/status.sh)"
fi

echo ""

# Check nextjs
echo "Next.js App:"
if curl -s http://127.0.0.1:3001/ > /dev/null 2>&1; then
    echo "  ✓ Running on http://127.0.0.1:3001"
else
    echo "  ✗ Not running"
    echo "    (If using Docker, check with: ./docker/status.sh)"
fi

echo ""

# Check processes
echo "Running processes:"
PROCESSES=$(ps aux | grep -E "(uvicorn|next|node.*next)" | grep -v grep)
if [ -n "$PROCESSES" ]; then
    echo "$PROCESSES" | awk '{print "  - " $11 " " $12 " " $13}'
else
    echo "  (No local processes found)"
    echo "  (If using Docker, check with: ./docker/status.sh)"
fi

echo ""
echo "=== Access URLs ==="
echo "Next.js App: http://localhost:3001"
echo "Backend API: http://localhost:8000"
echo "API Docs: http://localhost:8000/docs"
echo ""
echo "For Docker services: ./docker/status.sh"

