#!/bin/bash
set -e

echo "🚀 Setting up development environment for Gaia Tools..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Workspace root: $WORKSPACE_ROOT"

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not found. Please install Python 3.11+"
    exit 1
fi

# Check if pip is available
if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
    echo "❌ pip is required but not found. Please install pip"
    exit 1
fi

PIP_CMD="pip3"
if command -v pip &> /dev/null; then
    PIP_CMD="pip"
fi

# Install Python packages in editable mode
echo ""
echo "📦 Installing Python packages in editable mode..."

if [ -d "$WORKSPACE_ROOT/crius-ephemeris-core" ]; then
    echo "  → Installing crius-ephemeris-core..."
    cd "$WORKSPACE_ROOT/crius-ephemeris-core"
    $PIP_CMD install -e . || echo "  ⚠️  Warning: Failed to install crius-ephemeris-core (may need virtualenv)"
    cd "$SCRIPT_DIR"
else
    echo "  ⚠️  crius-ephemeris-core not found at $WORKSPACE_ROOT/crius-ephemeris-core"
fi

if [ -d "$WORKSPACE_ROOT/crius-swiss" ]; then
    echo "  → Installing crius-swiss..."
    cd "$WORKSPACE_ROOT/crius-swiss"
    $PIP_CMD install -e . || echo "  ⚠️  Warning: Failed to install crius-swiss (may need virtualenv)"
    cd "$SCRIPT_DIR"
else
    echo "  ⚠️  crius-swiss not found at $WORKSPACE_ROOT/crius-swiss"
fi

if [ -d "$WORKSPACE_ROOT/coeus-api" ]; then
    echo "  → Installing coeus-api..."
    cd "$WORKSPACE_ROOT/coeus-api"
    $PIP_CMD install -e . || echo "  ⚠️  Warning: Failed to install coeus-api (may need virtualenv)"
    cd "$SCRIPT_DIR"
else
    echo "  ⚠️  coeus-api not found at $WORKSPACE_ROOT/coeus-api"
fi

# Check if pnpm is available
if ! command -v pnpm &> /dev/null; then
    echo ""
    echo "⚠️  pnpm is not installed. Installing Node.js dependencies will be skipped."
    echo "   Install pnpm: npm install -g pnpm"
else
    # Install Node.js dependencies
    echo ""
    echo "📦 Installing Node.js dependencies..."
    cd "$SCRIPT_DIR"
    pnpm install || echo "  ⚠️  Warning: Failed to install Node.js dependencies"
fi

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo ""
    echo "⚠️  Docker is not installed. Docker services will not be available."
    echo "   Install Docker: https://docs.docker.com/get-docker/"
else
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        echo ""
        echo "⚠️  Docker Compose is not available."
    else
        echo ""
        echo "🐳 Docker and Docker Compose are available"
    fi
fi

echo ""
echo "✅ Development environment setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run './dev.sh' to start all services and packages in development mode"
echo "  2. Or run 'docker compose up' to start only Docker services (postgres + backend)"
echo ""

