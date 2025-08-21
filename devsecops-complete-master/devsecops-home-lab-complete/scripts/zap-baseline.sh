#!/usr/bin/env bash
set -e
TARGET=${1:-http://127.0.0.1:30080}
docker run --rm -v $(pwd):/zap/wrk owasp/zap2docker-stable zap-baseline.py -t $TARGET -r zap-baseline.html || true
echo "Saved zap-baseline.html"
