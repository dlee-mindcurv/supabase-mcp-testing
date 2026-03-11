# Supabase Ecommerce Testing Project

Local Supabase development environment with a full ecommerce database schema and mock data for testing queries.

## Quick Start

```bash
# Start local Supabase (requires Docker running)
./scripts/setup.sh

# Reset database (re-apply migrations + seed)
./scripts/reset.sh

# Stop local Supabase
supabase stop
```

## Local Development URLs

| Service   | URL                                                              |
|-----------|------------------------------------------------------------------|
| Studio    | http://localhost:54323                                           |
| API       | http://localhost:54321                                           |
| Database  | `postgresql://postgres:postgres@localhost:54322/postgres`        |
| Mailpit   | http://localhost:54324                                           |

## Database Schema

| Table            | RLS | Description                              |
|------------------|-----|------------------------------------------|
| `profiles`       | Yes | User profiles (auto-created via trigger) |
| `categories`     | Yes | Product categories with subcategories    |
| `products`       | Yes | Products with JSONB attributes, tags     |
| `inventory`      | Yes | Stock levels with computed availability  |
| `addresses`      | Yes | User shipping/billing addresses          |
| `orders`         | Yes | Orders with auto-generated order numbers |
| `order_items`    | Yes | Line items with computed totals          |
| `reviews`        | Yes | Product reviews (1-5 rating)             |
| `shipments`      | Yes | Shipping tracking                        |
| `payments`       | Yes | Payment records                          |
| `wishlist_items` | Yes | User wishlists                           |
| `discounts`      | Yes | Coupon codes                             |
| `order_discounts`| Yes | Applied coupons junction table           |

### Enums

- `order_status`: pending, confirmed, processing, shipped, delivered, cancelled, refunded
- `payment_status`: pending, completed, failed, refunded
- `payment_method`: credit_card, debit_card, paypal, bank_transfer, crypto
- `shipment_status`: label_created, picked_up, in_transit, out_for_delivery, delivered, returned
- `discount_type`: percentage, fixed_amount, free_shipping

## Test Users

All passwords: `password123`

| Name            | Email              | UUID                                   |
|-----------------|--------------------|----------------------------------------|
| Alice Johnson   | alice@example.com  | a1111111-1111-1111-1111-111111111111   |
| Bob Smith       | bob@example.com    | b2222222-2222-2222-2222-222222222222   |
| Carol Williams  | carol@example.com  | c3333333-3333-3333-3333-333333333333   |
| Dave Brown      | dave@example.com   | d4444444-4444-4444-4444-444444444444   |
| Eve Davis       | eve@example.com    | e5555555-5555-5555-5555-555555555555   |

## Seed Data Summary

- 5 users, 10 categories, 30 products, 30 inventory records
- 7 addresses, 5 discount codes, 15 orders, 19+ order items
- 10 reviews, 14 payments, 8 shipments, 5 order discounts, 9 wishlist items

## Common CLI Commands

```bash
supabase start              # Start local stack
supabase stop               # Stop local stack
supabase db reset           # Reset DB (migrations + seed)
supabase migration new NAME # Create new migration
supabase db diff            # Diff live DB vs migrations
supabase db push            # Push migrations to remote
supabase db push --dry-run  # Preview remote push
supabase status             # Show local service URLs/keys
```

## Deployment Workflow

```bash
# 1. Link to remote project (once)
./scripts/link-remote.sh <project-ref>

# 2. Deploy migrations
./scripts/deploy.sh
```

## Product Search Demo App

Natural language product search UI in `product-search/`. Uses local Ollama + Supabase MCP to translate queries into SQL.

### Architecture

```
UI (Next.js) → API route → Ollama (qwen3:8b) with MCP tools → Supabase MCP Server → Local Postgres
```

### Stack

- **Next.js 16** (App Router) with Tailwind CSS
- **Vercel AI SDK v6** (`ai`, `@ai-sdk/react`) — streaming chat + tool-use loop
- **ai-sdk-ollama** — Ollama provider for AI SDK
- **@ai-sdk/mcp** — bridges MCP tools into AI SDK format
- **Ollama** at `http://localhost:11434` with `qwen3:8b`
- **Supabase MCP** at `http://localhost:54321/mcp`

### Running the Demo

```bash
# Prerequisites: Docker running, Ollama running with qwen3:8b
supabase start                          # From project root
cd product-search && npm run dev        # http://localhost:3000
```

### Key Files

- `product-search/src/app/api/chat/route.ts` — Core orchestration (MCP client + Ollama + streaming)
- `product-search/src/app/page.tsx` — Chat UI with useChat hook
- `product-search/src/lib/system-prompt.ts` — Schema context for the LLM
- `product-search/.env.local` — MCP URL + Ollama config

### Swapping Models

Change `OLLAMA_MODEL` in `.env.local` or the default in `route.ts`. Alternatives: `qwen2.5:14b`, `llama3.1:8b`, `mistral:7b-instruct`.

## File Structure

```
├── CLAUDE.md
├── .gitignore
├── scripts/
│   ├── setup.sh          # Initialize & start local Supabase
│   ├── reset.sh          # Reset database with confirmation
│   ├── link-remote.sh    # Link to remote Supabase project
│   └── deploy.sh         # Deploy migrations to remote
├── product-search/       # Next.js product search demo
│   ├── src/app/          # App Router pages + API routes
│   ├── src/lib/          # System prompt + utilities
│   ├── .env.local        # Local config (MCP URL, Ollama)
│   └── next.config.ts    # Server external packages config
└── supabase/
    ├── config.toml       # Supabase local configuration
    ├── seed.sql          # Test data
    └── migrations/
        ├── *_create_ecommerce_schema.sql
        ├── *_create_rls_policies.sql
        └── *_create_triggers_and_functions.sql
```

## Gotchas & Notes

- **Docker required**: Supabase local dev runs via Docker containers. Start Rancher Desktop / Docker Desktop first.
- **Analytics disabled**: The `analytics` container is disabled in `config.toml` due to a Docker socket mount issue with Rancher Desktop.
- **RLS performance**: Policies use `(SELECT auth.uid())` subselect pattern to avoid per-row re-evaluation.
- **Seed data**: `seed.sql` inserts directly into `auth.users` — this only works for local dev. In production, use the Supabase Auth API.
- **Order numbers**: Auto-generated by trigger in `ORD-YYYYMMDD-NNNNNN` format, but seed data uses explicit values.
- **`db reset` is destructive**: It drops and recreates the entire database. All data is lost and re-seeded.
