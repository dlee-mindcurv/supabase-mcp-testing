#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "=== Supabase Database Reset ==="
echo ""
echo "This will drop all data and re-apply migrations + seed data."
echo ""

read -p "Are you sure? (y/N): " confirm
if [[ "$confirm" != [yY] ]]; then
  echo "Aborted."
  exit 0
fi

echo ""
echo "Resetting database..."
supabase db reset

echo ""
echo "=== Reset Complete ==="
echo "All migrations and seed data have been re-applied."
