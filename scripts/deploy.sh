#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "=== Deploy Migrations to Remote ==="
echo ""

# Check if linked
if [ ! -f "supabase/.temp/project-ref" ]; then
  echo "ERROR: No remote project linked."
  echo "Run first: ./scripts/link-remote.sh <project-ref>"
  exit 1
fi

PROJECT_REF=$(cat supabase/.temp/project-ref)
echo "Target project: $PROJECT_REF"
echo ""

# Dry run first
echo "--- Dry Run ---"
supabase db push --dry-run
echo ""

read -p "Push these migrations to remote? (y/N): " confirm
if [[ "$confirm" != [yY] ]]; then
  echo "Aborted."
  exit 0
fi

echo ""
echo "Pushing migrations..."
supabase db push

echo ""
echo "=== Deploy Complete ==="
