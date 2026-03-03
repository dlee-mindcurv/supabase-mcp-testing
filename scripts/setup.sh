#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "=== Supabase Ecommerce Local Setup ==="

# Check prerequisites
echo ""
echo "Checking prerequisites..."

if ! command -v supabase &> /dev/null; then
  echo "ERROR: Supabase CLI is not installed."
  echo "Install it: brew install supabase/tap/supabase"
  exit 1
fi
echo "  Supabase CLI: $(supabase --version)"

if ! docker info &> /dev/null; then
  echo "ERROR: Docker is not running."
  echo "Start Docker Desktop or Rancher Desktop and try again."
  exit 1
fi
echo "  Docker: running"

# Initialize if needed
if [ ! -f "supabase/config.toml" ]; then
  echo ""
  echo "Initializing Supabase project..."
  supabase init
else
  echo "  Supabase project: already initialized"
fi

# Start local stack
echo ""
echo "Starting Supabase local stack..."
supabase start

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Studio:   http://localhost:54323"
echo "API:      http://localhost:54321"
echo "Database: postgresql://postgres:postgres@localhost:54322/postgres"
