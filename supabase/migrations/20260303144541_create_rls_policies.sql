-- ============================================================================
-- Migration 2: Row Level Security Policies
-- ============================================================================

-- ---------- Enable RLS on all user-facing tables ----------

ALTER TABLE profiles       ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories     ENABLE ROW LEVEL SECURITY;
ALTER TABLE products       ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory      ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses      ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders         ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items    ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews        ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipments      ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments       ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE discounts      ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_discounts ENABLE ROW LEVEL SECURITY;

-- ---------- Profiles ----------

CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (id = (SELECT auth.uid()));

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (id = (SELECT auth.uid()))
  WITH CHECK (id = (SELECT auth.uid()));

-- ---------- Categories (public read) ----------

CREATE POLICY "Anyone can view categories"
  ON categories FOR SELECT
  USING (true);

-- ---------- Products (public read for active) ----------

CREATE POLICY "Anyone can view active products"
  ON products FOR SELECT
  USING (is_active = true);

-- ---------- Inventory (public read) ----------

CREATE POLICY "Anyone can view inventory"
  ON inventory FOR SELECT
  USING (true);

-- ---------- Addresses (own data only) ----------

CREATE POLICY "Users can view own addresses"
  ON addresses FOR SELECT
  USING (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can insert own addresses"
  ON addresses FOR INSERT
  WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can update own addresses"
  ON addresses FOR UPDATE
  USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can delete own addresses"
  ON addresses FOR DELETE
  USING (user_id = (SELECT auth.uid()));

-- ---------- Orders (own data only) ----------

CREATE POLICY "Users can view own orders"
  ON orders FOR SELECT
  USING (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can insert own orders"
  ON orders FOR INSERT
  WITH CHECK (user_id = (SELECT auth.uid()));

-- ---------- Order Items (via order ownership) ----------

CREATE POLICY "Users can view own order items"
  ON order_items FOR SELECT
  USING (
    order_id IN (
      SELECT id FROM orders WHERE user_id = (SELECT auth.uid())
    )
  );

CREATE POLICY "Users can insert own order items"
  ON order_items FOR INSERT
  WITH CHECK (
    order_id IN (
      SELECT id FROM orders WHERE user_id = (SELECT auth.uid())
    )
  );

-- ---------- Reviews (public read, authenticated write own) ----------

CREATE POLICY "Anyone can view reviews"
  ON reviews FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can insert own reviews"
  ON reviews FOR INSERT
  WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can update own reviews"
  ON reviews FOR UPDATE
  USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can delete own reviews"
  ON reviews FOR DELETE
  USING (user_id = (SELECT auth.uid()));

-- ---------- Shipments (via order ownership) ----------

CREATE POLICY "Users can view own shipments"
  ON shipments FOR SELECT
  USING (
    order_id IN (
      SELECT id FROM orders WHERE user_id = (SELECT auth.uid())
    )
  );

-- ---------- Payments (via order ownership) ----------

CREATE POLICY "Users can view own payments"
  ON payments FOR SELECT
  USING (
    order_id IN (
      SELECT id FROM orders WHERE user_id = (SELECT auth.uid())
    )
  );

-- ---------- Wishlist Items (own data only) ----------

CREATE POLICY "Users can view own wishlist"
  ON wishlist_items FOR SELECT
  USING (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can insert own wishlist items"
  ON wishlist_items FOR INSERT
  WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can delete own wishlist items"
  ON wishlist_items FOR DELETE
  USING (user_id = (SELECT auth.uid()));

-- ---------- Discounts (public read for active/valid) ----------

CREATE POLICY "Anyone can view active discounts"
  ON discounts FOR SELECT
  USING (
    is_active = true
    AND starts_at <= now()
    AND (expires_at IS NULL OR expires_at > now())
  );

-- ---------- Order Discounts (via order ownership) ----------

CREATE POLICY "Users can view own order discounts"
  ON order_discounts FOR SELECT
  USING (
    order_id IN (
      SELECT id FROM orders WHERE user_id = (SELECT auth.uid())
    )
  );

CREATE POLICY "Users can insert own order discounts"
  ON order_discounts FOR INSERT
  WITH CHECK (
    order_id IN (
      SELECT id FROM orders WHERE user_id = (SELECT auth.uid())
    )
  );
