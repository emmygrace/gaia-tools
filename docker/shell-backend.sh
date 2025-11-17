#!/bin/bash
# Open a shell in the backend container

set -e

cd "$(dirname "$0")/.."

echo "Opening backend shell..."
docker compose exec coeus-api-backend /bin/sh

