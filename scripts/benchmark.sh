#!/bin/bash
# Performance benchmarking script
# Usage: ./scripts/benchmark.sh [endpoint]

set -e

API_URL=${API_URL:-http://localhost:8000}
ENDPOINT=${1:-/api/render}

echo "Benchmarking $API_URL$ENDPOINT"

# Sample request payload
PAYLOAD='{
  "subjects": [{
    "id": "test",
    "birthDateTime": "1990-01-01T12:00:00Z",
    "location": {"lat": 40.7128, "lon": -74.0060}
  }],
  "settings": {
    "zodiacType": "tropical",
    "houseSystem": "placidus",
    "includeObjects": ["sun", "moon"]
  },
  "layer_config": {
    "natal": {"kind": "natal", "subjectId": "test"}
  }
}'

# Run benchmarks
echo "Running 100 requests..."
time for i in {1..100}; do
  curl -s -X POST "$API_URL$ENDPOINT" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" > /dev/null
done

echo "Benchmark complete!"

