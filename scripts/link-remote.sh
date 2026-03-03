#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "=== Link Remote Supabase Project ==="
echo ""

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <project-ref>"
  echo ""
  echo "Find your project ref in the Supabase dashboard:"
  echo "  Settings > General > Reference ID"
  echo ""
  echo "Example: $0 abcdefghijklmnop"
  exit 1
fi

PROJECT_REF="$1"

echo "Linking to project: $PROJECT_REF"
echo ""

supabase link --project-ref "$PROJECT_REF"

echo ""
echo "=== Link Complete ==="
echo "You can now deploy migrations with: ./scripts/deploy.sh"
