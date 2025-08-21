#!/bin/bash
set -e
if ! command -v checkov >/dev/null 2>&1; then
  pip3 install --user checkov
fi
~/.local/bin/checkov -d k8s/ || true
