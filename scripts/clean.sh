#!/bin/bash
# Clean build artifacts
# Usage: ./scripts/clean.sh

set -e

echo "Cleaning build artifacts..."

# Python artifacts
find .. -type d -name "__pycache__" -exec rm -r {} + 2>/dev/null || true
find .. -type d -name "*.egg-info" -exec rm -r {} + 2>/dev/null || true
find .. -type d -name "dist" -exec rm -r {} + 2>/dev/null || true
find .. -type d -name "build" -exec rm -r {} + 2>/dev/null || true
find .. -type f -name "*.pyc" -delete 2>/dev/null || true
find .. -type f -name "*.pyo" -delete 2>/dev/null || true

# Node artifacts
find .. -type d -name "node_modules" -prune -o -type d -name ".next" -exec rm -r {} + 2>/dev/null || true
find .. -type d -name "dist" -exec rm -r {} + 2>/dev/null || true
find .. -type d -name "build" -exec rm -r {} + 2>/dev/null || true
find .. -type f -name "*.tsbuildinfo" -delete 2>/dev/null || true

# Coverage reports
find .. -type d -name "htmlcov" -exec rm -r {} + 2>/dev/null || true
find .. -type f -name ".coverage" -delete 2>/dev/null || true
find .. -type f -name "coverage.xml" -delete 2>/dev/null || true

# Test artifacts
find .. -type d -name ".pytest_cache" -exec rm -r {} + 2>/dev/null || true
find .. -type d -name ".mypy_cache" -exec rm -r {} + 2>/dev/null || true
find .. -type d -name ".ruff_cache" -exec rm -r {} + 2>/dev/null || true

echo "Clean complete!"

