#!/usr/bin/env bash
# Create a weekly git snapshot tag
set -euo pipefail
cd "$(dirname "$0")/.."
TAG="week_$(date +%Y)_W$(date +%V)"
git tag "$TAG" -m "Weekly snapshot: $TAG"
echo "Tagged: $TAG"
