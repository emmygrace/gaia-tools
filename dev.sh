#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🚀 Starting Gaia Tools development environment..."
echo "Workspace root: $WORKSPACE_ROOT"
echo ""

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Shutting down development environment..."
    
    # Kill background processes
    if [ ! -z "$PNPM_PID" ]; then
        echo "  → Stopping TypeScript packages..."
        kill $PNPM_PID 2>/dev/null || true
    fi
    
    # Stop Docker services
    if command -v docker &> /dev/null && (command -v docker-compose &> /dev/null || docker compose version &> /dev/null); then
        echo "  → Stopping Docker services..."
        cd "$SCRIPT_DIR"
        docker compose down
    fi
    
    echo "✅ Shutdown complete"
    exit 0
}

# Set up trap for cleanup
trap cleanup INT TERM

# Start Docker services
if command -v docker &> /dev/null && (command -v docker-compose &> /dev/null || docker compose version &> /dev/null); then
    echo "🐳 Starting Docker services (postgres + coeus-api-backend)..."
    cd "$SCRIPT_DIR"
    docker compose up -d
    
    # Wait for backend to be healthy
    echo "  → Waiting for backend to be ready..."
    MAX_WAIT=60
    WAIT_COUNT=0
    while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
        if docker compose ps coeus-api-backend | grep -q "healthy"; then
            echo "  ✅ Backend is ready!"
            break
        fi
        sleep 2
        WAIT_COUNT=$((WAIT_COUNT + 2))
        echo -n "."
    done
    echo ""
    
    if [ $WAIT_COUNT -ge $MAX_WAIT ]; then
        echo "  ⚠️  Backend health check timeout, but continuing anyway..."
    fi
else
    echo "⚠️  Docker not available, skipping Docker services"
fi

# Start TypeScript packages in watch mode
if command -v pnpm &> /dev/null; then
    echo ""
    echo "📦 Starting TypeScript packages in watch mode..."
    cd "$SCRIPT_DIR"
    pnpm -r --parallel dev > /tmp/gaia-pnpm.log 2>&1 &
    PNPM_PID=$!
    echo "  → TypeScript packages started (PID: $PNPM_PID)"
    echo "  → Logs: tail -f /tmp/gaia-pnpm.log"
else
    echo "⚠️  pnpm not available, skipping TypeScript packages"
fi

echo ""
echo "✅ Development environment is running!"
echo ""
echo "Services:"
echo "  • PostgreSQL: localhost:5432"
echo "  • Backend API: http://localhost:8000"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Wait for user interrupt
wait

