#!/bin/bash
set -e
if ! command -v conftest >/dev/null 2>&1; then
  wget -qO- https://github.com/open-policy-agent/conftest/releases/latest/download/conftest_Linux_x86_64.tar.gz | tar xz
  sudo mv conftest /usr/local/bin/
fi
conftest test k8s/ --policy security/conftest-policies || true
