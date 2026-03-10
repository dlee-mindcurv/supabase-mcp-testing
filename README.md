# Supabase Ecommerce Testing Project

Local Supabase development environment with a full ecommerce database schema and mock data for testing queries.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) or [Rancher Desktop](https://rancherdesktop.io/)
- [Supabase CLI](https://supabase.com/docs/guides/cli/getting-started) (`brew install supabase/tap/supabase`)

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

| Service  | URL                                                       |
|----------|-----------------------------------------------------------|
| Studio   | http://localhost:54323                                    |
| API      | http://localhost:54321                                    |
| Database | `postgresql://postgres:postgres@localhost:54322/postgres` |
| Mailpit  | http://localhost:54324                                    |

## Database Schema

### Tables

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

| Enum              | Values                                                                              |
|-------------------|--------------------------------------------------------------------------------------|
| `order_status`    | pending, confirmed, processing, shipped, delivered, cancelled, refunded             |
| `payment_status`  | pending, completed, failed, refunded                                                |
| `payment_method`  | credit_card, debit_card, paypal, bank_transfer, crypto                              |
| `shipment_status` | label_created, picked_up, in_transit, out_for_delivery, delivered, returned          |
| `discount_type`   | percentage, fixed_amount, free_shipping                                             |

## Test Users

All passwords: `password123`

| Name            | Email              | UUID                                 |
|-----------------|--------------------|--------------------------------------|
| Alice Johnson   | alice@example.com  | a1111111-1111-1111-1111-111111111111 |
| Bob Smith       | bob@example.com    | b2222222-2222-2222-2222-222222222222 |
| Carol Williams  | carol@example.com  | c3333333-3333-3333-3333-333333333333 |
| Dave Brown      | dave@example.com   | d4444444-4444-4444-4444-444444444444 |
| Eve Davis       | eve@example.com    | e5555555-5555-5555-5555-555555555555 |

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

## Deployment

```bash
# 1. Link to remote project (once)
./scripts/link-remote.sh <project-ref>

# 2. Deploy migrations
./scripts/deploy.sh
```

## Product Search Demo

A Next.js app that lets you search products using natural language, powered by local Ollama and the Supabase MCP server.

### Prerequisites

- [Ollama](https://ollama.ai/) with `qwen3:8b` model (`ollama pull qwen3:8b`)
- [Node.js](https://nodejs.org/) 18+

### Running

```bash
# 1. Start Supabase (from project root)
supabase start

# 2. Start the demo app
cd product-search
npm install
npm run dev
# Open http://localhost:3000
```

### Example Queries

- "Show me smartphones under $900"
- "What books do you have?"
- "Find Apple products"
- "Highest rated products in stock"

## Project Structure

```
├── README.md
├── CLAUDE.md
├── .gitignore
├── scripts/
│   ├── setup.sh          # Initialize & start local Supabase
│   ├── reset.sh          # Reset database with confirmation
│   ├── link-remote.sh    # Link to remote Supabase project
│   └── deploy.sh         # Deploy migrations to remote
├── product-search/       # Next.js product search demo app
│   ├── src/app/          # App Router pages + API routes
│   ├── src/lib/          # System prompt with schema context
│   └── .env.local        # Local config (MCP URL, Ollama)
└── supabase/
    ├── config.toml       # Supabase local configuration
    ├── seed.sql          # Test data
    └── migrations/
        ├── *_create_ecommerce_schema.sql
        ├── *_create_rls_policies.sql
        └── *_create_triggers_and_functions.sql
```

## Notes

- **Docker required** -- Supabase local dev runs via Docker containers. Start Docker Desktop or Rancher Desktop first.
- **Analytics disabled** -- The `analytics` container is disabled in `config.toml` to avoid Docker socket mount issues.
- **RLS policies** use the `(SELECT auth.uid())` subselect pattern to avoid per-row re-evaluation.
- **Seed data** inserts directly into `auth.users` -- this only works for local dev. In production, use the Supabase Auth API.
- **Order numbers** are auto-generated by trigger in `ORD-YYYYMMDD-NNNNNN` format (seed data uses explicit values).
- **`db reset` is destructive** -- it drops and recreates the entire database.
