-- ============================================================================
-- Migration 1: Ecommerce Schema — Enums, Tables, Indexes
-- ============================================================================

-- ---------- Enums ----------

CREATE TYPE order_status AS ENUM (
  'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded'
);

CREATE TYPE payment_status AS ENUM (
  'pending', 'completed', 'failed', 'refunded'
);

CREATE TYPE payment_method AS ENUM (
  'credit_card', 'debit_card', 'paypal', 'bank_transfer', 'crypto'
);

CREATE TYPE shipment_status AS ENUM (
  'label_created', 'picked_up', 'in_transit', 'out_for_delivery', 'delivered', 'returned'
);

CREATE TYPE discount_type AS ENUM (
  'percentage', 'fixed_amount', 'free_shipping'
);

-- ---------- Tables ----------

-- 1. Profiles (extends auth.users)
CREATE TABLE profiles (
  id          uuid PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  full_name   text,
  avatar_url  text,
  phone       text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

-- 2. Categories (self-referencing for subcategories)
CREATE TABLE categories (
  id                  bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name                text NOT NULL,
  slug                text NOT NULL UNIQUE,
  description         text,
  parent_category_id  bigint REFERENCES categories ON DELETE SET NULL,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_categories_parent ON categories (parent_category_id);

-- 3. Products
CREATE TABLE products (
  id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name          text NOT NULL,
  slug          text NOT NULL UNIQUE,
  description   text,
  price         numeric(10,2) NOT NULL CHECK (price >= 0),
  compare_price numeric(10,2) CHECK (compare_price IS NULL OR compare_price >= 0),
  sku           text UNIQUE,
  category_id   bigint REFERENCES categories ON DELETE SET NULL,
  attributes    jsonb DEFAULT '{}'::jsonb,
  tags          text[] DEFAULT '{}',
  is_active     boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_products_category ON products (category_id);
CREATE INDEX idx_products_active ON products (is_active) WHERE is_active = true;
CREATE INDEX idx_products_tags ON products USING GIN (tags);
CREATE INDEX idx_products_attributes ON products USING GIN (attributes);

-- 4. Inventory (1-to-1 with products)
CREATE TABLE inventory (
  id                  bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  product_id          bigint NOT NULL UNIQUE REFERENCES products ON DELETE CASCADE,
  quantity_on_hand    int NOT NULL DEFAULT 0 CHECK (quantity_on_hand >= 0),
  quantity_reserved   int NOT NULL DEFAULT 0 CHECK (quantity_reserved >= 0),
  quantity_available  int GENERATED ALWAYS AS (quantity_on_hand - quantity_reserved) STORED,
  low_stock_threshold int NOT NULL DEFAULT 10,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now()
);

-- 5. Addresses
CREATE TABLE addresses (
  id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id     uuid NOT NULL REFERENCES auth.users ON DELETE CASCADE,
  label       text NOT NULL DEFAULT 'home',
  line1       text NOT NULL,
  line2       text,
  city        text NOT NULL,
  state       text NOT NULL,
  postal_code text NOT NULL,
  country     text NOT NULL DEFAULT 'US',
  is_default  boolean NOT NULL DEFAULT false,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_addresses_user ON addresses (user_id);

-- 6. Orders
CREATE TABLE orders (
  id                  bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_number        text UNIQUE,
  user_id             uuid NOT NULL REFERENCES auth.users ON DELETE RESTRICT,
  status              order_status NOT NULL DEFAULT 'pending',
  subtotal            numeric(10,2) NOT NULL DEFAULT 0 CHECK (subtotal >= 0),
  discount_total      numeric(10,2) NOT NULL DEFAULT 0 CHECK (discount_total >= 0),
  shipping_total      numeric(10,2) NOT NULL DEFAULT 0 CHECK (shipping_total >= 0),
  tax_total           numeric(10,2) NOT NULL DEFAULT 0 CHECK (tax_total >= 0),
  total               numeric(10,2) NOT NULL DEFAULT 0 CHECK (total >= 0),
  shipping_address_id bigint REFERENCES addresses ON DELETE SET NULL,
  notes               text,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_orders_user ON orders (user_id);
CREATE INDEX idx_orders_status ON orders (status);

-- 7. Order Items
CREATE TABLE order_items (
  id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id    bigint NOT NULL REFERENCES orders ON DELETE CASCADE,
  product_id  bigint NOT NULL REFERENCES products ON DELETE RESTRICT,
  quantity    int NOT NULL CHECK (quantity > 0),
  unit_price  numeric(10,2) NOT NULL CHECK (unit_price >= 0),
  line_total  numeric(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_order_items_order ON order_items (order_id);
CREATE INDEX idx_order_items_product ON order_items (product_id);

-- 8. Reviews
CREATE TABLE reviews (
  id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  product_id  bigint NOT NULL REFERENCES products ON DELETE CASCADE,
  user_id     uuid NOT NULL REFERENCES auth.users ON DELETE CASCADE,
  rating      int NOT NULL CHECK (rating BETWEEN 1 AND 5),
  title       text,
  body        text,
  is_verified boolean NOT NULL DEFAULT false,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (product_id, user_id)
);

CREATE INDEX idx_reviews_product ON reviews (product_id);
CREATE INDEX idx_reviews_user ON reviews (user_id);

-- 9. Shipments
CREATE TABLE shipments (
  id              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id        bigint NOT NULL REFERENCES orders ON DELETE CASCADE,
  carrier         text,
  tracking_number text,
  status          shipment_status NOT NULL DEFAULT 'label_created',
  shipped_at      timestamptz,
  delivered_at    timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_shipments_order ON shipments (order_id);

-- 10. Payments
CREATE TABLE payments (
  id              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id        bigint NOT NULL REFERENCES orders ON DELETE CASCADE,
  method          payment_method NOT NULL,
  status          payment_status NOT NULL DEFAULT 'pending',
  amount          numeric(10,2) NOT NULL CHECK (amount >= 0),
  transaction_id  text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_payments_order ON payments (order_id);

-- 11. Wishlist Items
CREATE TABLE wishlist_items (
  id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id     uuid NOT NULL REFERENCES auth.users ON DELETE CASCADE,
  product_id  bigint NOT NULL REFERENCES products ON DELETE CASCADE,
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, product_id)
);

CREATE INDEX idx_wishlist_user ON wishlist_items (user_id);

-- 12. Discounts
CREATE TABLE discounts (
  id              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  code            text NOT NULL UNIQUE,
  description     text,
  type            discount_type NOT NULL,
  value           numeric(10,2) NOT NULL CHECK (value >= 0),
  min_order_value numeric(10,2) DEFAULT 0,
  max_uses        int,
  current_uses    int NOT NULL DEFAULT 0,
  starts_at       timestamptz NOT NULL DEFAULT now(),
  expires_at      timestamptz,
  is_active       boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

-- 13. Order Discounts (junction)
CREATE TABLE order_discounts (
  id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id    bigint NOT NULL REFERENCES orders ON DELETE CASCADE,
  discount_id bigint NOT NULL REFERENCES discounts ON DELETE RESTRICT,
  amount      numeric(10,2) NOT NULL CHECK (amount >= 0),
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (order_id, discount_id)
);

CREATE INDEX idx_order_discounts_order ON order_discounts (order_id);
