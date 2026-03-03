-- ============================================================================
-- Seed Data: Ecommerce Test Data
-- ============================================================================
-- This file is run automatically on `supabase db reset`.
-- It uses the Supabase auth admin API to create test users.

-- ---------- 1. Test Users (5) ----------
-- Password for all: password123

-- We insert directly into auth.users for local dev seeding.
-- The handle_new_user trigger will auto-create profiles.

INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, created_at, updated_at,
  raw_user_meta_data, confirmation_token, recovery_token,
  email_change_token_new, email_change
) VALUES
  ('00000000-0000-0000-0000-000000000000', 'a1111111-1111-1111-1111-111111111111', 'authenticated', 'authenticated',
   'alice@example.com', crypt('password123', gen_salt('bf')),
   now(), now(), now(),
   '{"full_name": "Alice Johnson"}'::jsonb, '', '', '', ''),

  ('00000000-0000-0000-0000-000000000000', 'b2222222-2222-2222-2222-222222222222', 'authenticated', 'authenticated',
   'bob@example.com', crypt('password123', gen_salt('bf')),
   now(), now(), now(),
   '{"full_name": "Bob Smith"}'::jsonb, '', '', '', ''),

  ('00000000-0000-0000-0000-000000000000', 'c3333333-3333-3333-3333-333333333333', 'authenticated', 'authenticated',
   'carol@example.com', crypt('password123', gen_salt('bf')),
   now(), now(), now(),
   '{"full_name": "Carol Williams"}'::jsonb, '', '', '', ''),

  ('00000000-0000-0000-0000-000000000000', 'd4444444-4444-4444-4444-444444444444', 'authenticated', 'authenticated',
   'dave@example.com', crypt('password123', gen_salt('bf')),
   now(), now(), now(),
   '{"full_name": "Dave Brown"}'::jsonb, '', '', '', ''),

  ('00000000-0000-0000-0000-000000000000', 'e5555555-5555-5555-5555-555555555555', 'authenticated', 'authenticated',
   'eve@example.com', crypt('password123', gen_salt('bf')),
   now(), now(), now(),
   '{"full_name": "Eve Davis"}'::jsonb, '', '', '', '');

-- Create identities for each user (required for auth to work properly)
INSERT INTO auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
VALUES
  ('a1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111',
   json_build_object('sub', 'a1111111-1111-1111-1111-111111111111', 'email', 'alice@example.com')::jsonb,
   'email', now(), now(), now()),
  ('b2222222-2222-2222-2222-222222222222', 'b2222222-2222-2222-2222-222222222222', 'b2222222-2222-2222-2222-222222222222',
   json_build_object('sub', 'b2222222-2222-2222-2222-222222222222', 'email', 'bob@example.com')::jsonb,
   'email', now(), now(), now()),
  ('c3333333-3333-3333-3333-333333333333', 'c3333333-3333-3333-3333-333333333333', 'c3333333-3333-3333-3333-333333333333',
   json_build_object('sub', 'c3333333-3333-3333-3333-333333333333', 'email', 'carol@example.com')::jsonb,
   'email', now(), now(), now()),
  ('d4444444-4444-4444-4444-444444444444', 'd4444444-4444-4444-4444-444444444444', 'd4444444-4444-4444-4444-444444444444',
   json_build_object('sub', 'd4444444-4444-4444-4444-444444444444', 'email', 'dave@example.com')::jsonb,
   'email', now(), now(), now()),
  ('e5555555-5555-5555-5555-555555555555', 'e5555555-5555-5555-5555-555555555555', 'e5555555-5555-5555-5555-555555555555',
   json_build_object('sub', 'e5555555-5555-5555-5555-555555555555', 'email', 'eve@example.com')::jsonb,
   'email', now(), now(), now());

-- ---------- 2. Categories (10: 5 top-level + 5 subcategories) ----------

INSERT INTO categories (name, slug, description, parent_category_id) VALUES
  ('Electronics',    'electronics',    'Electronic devices and accessories', NULL),
  ('Clothing',       'clothing',       'Apparel and fashion items', NULL),
  ('Home & Garden',  'home-garden',    'Home decor and garden supplies', NULL),
  ('Books',          'books',          'Physical and digital books', NULL),
  ('Sports',         'sports',         'Sports equipment and outdoor gear', NULL),
  ('Smartphones',    'smartphones',    'Mobile phones and accessories', 1),
  ('Laptops',        'laptops',        'Portable computers', 1),
  ('Men''s Wear',    'mens-wear',      'Clothing for men', 2),
  ('Kitchen',        'kitchen',        'Kitchen appliances and tools', 3),
  ('Fiction',        'fiction',        'Fiction books and novels', 4);

-- ---------- 3. Products (30) ----------

INSERT INTO products (name, slug, description, price, compare_price, sku, category_id, attributes, tags) VALUES
  -- Electronics > Smartphones (cat 6)
  ('iPhone 15 Pro', 'iphone-15-pro', 'Latest Apple smartphone with A17 chip', 999.99, 1099.99, 'ELEC-IP15P', 6,
   '{"brand": "Apple", "storage": "256GB", "color": "Natural Titanium"}'::jsonb, ARRAY['apple', 'smartphone', 'premium']),
  ('Samsung Galaxy S24', 'samsung-galaxy-s24', 'Samsung flagship with AI features', 849.99, NULL, 'ELEC-SGS24', 6,
   '{"brand": "Samsung", "storage": "128GB", "color": "Phantom Black"}'::jsonb, ARRAY['samsung', 'smartphone', 'android']),
  ('Google Pixel 8', 'google-pixel-8', 'Google phone with best-in-class camera', 699.99, 749.99, 'ELEC-GP8', 6,
   '{"brand": "Google", "storage": "128GB", "color": "Obsidian"}'::jsonb, ARRAY['google', 'smartphone', 'camera']),
  ('OnePlus 12', 'oneplus-12', 'Flagship killer with fast charging', 799.99, NULL, 'ELEC-OP12', 6,
   '{"brand": "OnePlus", "storage": "256GB", "color": "Flowy Emerald"}'::jsonb, ARRAY['oneplus', 'smartphone', 'fast-charging']),

  -- Electronics > Laptops (cat 7)
  ('MacBook Pro 14"', 'macbook-pro-14', 'Apple laptop with M3 Pro chip', 1999.99, NULL, 'ELEC-MBP14', 7,
   '{"brand": "Apple", "ram": "18GB", "storage": "512GB SSD"}'::jsonb, ARRAY['apple', 'laptop', 'professional']),
  ('Dell XPS 15', 'dell-xps-15', 'Premium Windows ultrabook', 1499.99, 1599.99, 'ELEC-DX15', 7,
   '{"brand": "Dell", "ram": "16GB", "storage": "512GB SSD"}'::jsonb, ARRAY['dell', 'laptop', 'ultrabook']),
  ('ThinkPad X1 Carbon', 'thinkpad-x1-carbon', 'Legendary business laptop', 1349.99, NULL, 'ELEC-TX1C', 7,
   '{"brand": "Lenovo", "ram": "16GB", "storage": "256GB SSD"}'::jsonb, ARRAY['lenovo', 'laptop', 'business']),

  -- Clothing > Men's Wear (cat 8)
  ('Classic Oxford Shirt', 'classic-oxford-shirt', 'Button-down cotton oxford shirt', 59.99, 79.99, 'CLO-OXF01', 8,
   '{"material": "100% Cotton", "fit": "Regular", "sizes": ["S","M","L","XL"]}'::jsonb, ARRAY['shirt', 'formal', 'cotton']),
  ('Slim Fit Chinos', 'slim-fit-chinos', 'Comfortable stretch chino pants', 49.99, NULL, 'CLO-CHI01', 8,
   '{"material": "98% Cotton 2% Elastane", "fit": "Slim", "sizes": ["30","32","34","36"]}'::jsonb, ARRAY['pants', 'casual', 'stretch']),
  ('Merino Wool Sweater', 'merino-wool-sweater', 'Lightweight merino crew neck', 89.99, 119.99, 'CLO-MWS01', 8,
   '{"material": "100% Merino Wool", "fit": "Regular", "sizes": ["S","M","L","XL"]}'::jsonb, ARRAY['sweater', 'wool', 'winter']),
  ('Denim Jacket', 'denim-jacket', 'Classic trucker-style denim jacket', 79.99, NULL, 'CLO-DNJ01', 8,
   '{"material": "100% Denim", "fit": "Regular", "sizes": ["S","M","L","XL"]}'::jsonb, ARRAY['jacket', 'denim', 'casual']),

  -- Clothing (general, cat 2)
  ('Running Sneakers', 'running-sneakers', 'Lightweight running shoes', 129.99, 149.99, 'CLO-RUN01', 2,
   '{"brand": "Athletic Co", "sizes": ["8","9","10","11","12"]}'::jsonb, ARRAY['shoes', 'running', 'athletic']),
  ('Leather Belt', 'leather-belt', 'Genuine leather dress belt', 34.99, NULL, 'CLO-BLT01', 2,
   '{"material": "Genuine Leather", "sizes": ["S","M","L"]}'::jsonb, ARRAY['belt', 'leather', 'accessory']),

  -- Home & Garden > Kitchen (cat 9)
  ('Stand Mixer', 'stand-mixer', 'Professional 5-quart stand mixer', 349.99, 399.99, 'HOM-MIX01', 9,
   '{"brand": "KitchenPro", "capacity": "5 quart", "color": "Empire Red"}'::jsonb, ARRAY['mixer', 'baking', 'kitchen']),
  ('Chef''s Knife Set', 'chefs-knife-set', '8-piece professional knife set with block', 199.99, NULL, 'HOM-KNF01', 9,
   '{"brand": "SharpEdge", "pieces": 8, "material": "German Steel"}'::jsonb, ARRAY['knives', 'cooking', 'professional']),
  ('Espresso Machine', 'espresso-machine', 'Semi-automatic espresso maker', 449.99, 499.99, 'HOM-ESP01', 9,
   '{"brand": "BrewMaster", "type": "Semi-automatic", "pressure": "15 bar"}'::jsonb, ARRAY['coffee', 'espresso', 'kitchen']),
  ('Cast Iron Skillet', 'cast-iron-skillet', 'Pre-seasoned 12-inch cast iron skillet', 39.99, NULL, 'HOM-CIS01', 9,
   '{"brand": "IronCraft", "size": "12 inch", "material": "Cast Iron"}'::jsonb, ARRAY['skillet', 'cast-iron', 'cooking']),

  -- Home & Garden (general, cat 3)
  ('Scented Candle Set', 'scented-candle-set', 'Set of 3 luxury scented soy candles', 29.99, NULL, 'HOM-CAN01', 3,
   '{"type": "Soy", "count": 3, "burn_time": "40 hours each"}'::jsonb, ARRAY['candles', 'home-decor', 'gift']),
  ('Indoor Plant Pot', 'indoor-plant-pot', 'Ceramic pot with bamboo saucer', 24.99, 29.99, 'HOM-POT01', 3,
   '{"material": "Ceramic", "diameter": "8 inch"}'::jsonb, ARRAY['plant', 'ceramic', 'indoor']),

  -- Books > Fiction (cat 10)
  ('The Great Adventure', 'the-great-adventure', 'A thrilling epic fantasy novel', 14.99, NULL, 'BOK-TGA01', 10,
   '{"author": "J.R. Quill", "pages": 420, "format": "Paperback"}'::jsonb, ARRAY['fantasy', 'adventure', 'fiction']),
  ('Mystery at Midnight', 'mystery-at-midnight', 'A gripping detective mystery', 12.99, 15.99, 'BOK-MAM01', 10,
   '{"author": "Sarah Noir", "pages": 310, "format": "Paperback"}'::jsonb, ARRAY['mystery', 'detective', 'fiction']),
  ('Code & Coffee', 'code-and-coffee', 'A programmer''s journey to startup success', 19.99, NULL, 'BOK-CAC01', 10,
   '{"author": "Dev Patel", "pages": 280, "format": "Hardcover"}'::jsonb, ARRAY['tech', 'startup', 'fiction']),

  -- Books (general, cat 4)
  ('Cooking Fundamentals', 'cooking-fundamentals', 'Essential techniques for home cooks', 24.99, 29.99, 'BOK-CF01', 4,
   '{"author": "Chef Maria", "pages": 450, "format": "Hardcover"}'::jsonb, ARRAY['cooking', 'reference', 'non-fiction']),
  ('Gardening for Beginners', 'gardening-for-beginners', 'Complete guide to starting your garden', 16.99, NULL, 'BOK-GFB01', 4,
   '{"author": "Green Thumb", "pages": 220, "format": "Paperback"}'::jsonb, ARRAY['gardening', 'guide', 'non-fiction']),

  -- Sports (cat 5)
  ('Yoga Mat Premium', 'yoga-mat-premium', 'Extra thick non-slip yoga mat', 44.99, 54.99, 'SPT-YGM01', 5,
   '{"thickness": "6mm", "material": "TPE", "color": "Ocean Blue"}'::jsonb, ARRAY['yoga', 'fitness', 'mat']),
  ('Resistance Band Set', 'resistance-band-set', '5-piece resistance band set with handles', 29.99, NULL, 'SPT-RBS01', 5,
   '{"pieces": 5, "resistance_levels": ["Light","Medium","Heavy","X-Heavy","XX-Heavy"]}'::jsonb, ARRAY['fitness', 'resistance', 'home-workout']),
  ('Trail Running Backpack', 'trail-running-backpack', 'Lightweight 10L hydration-ready backpack', 69.99, 84.99, 'SPT-TRB01', 5,
   '{"capacity": "10L", "hydration_compatible": true, "weight": "280g"}'::jsonb, ARRAY['running', 'backpack', 'trail']),
  ('Camping Hammock', 'camping-hammock', 'Ultralight portable hammock with straps', 34.99, NULL, 'SPT-CHM01', 5,
   '{"weight_capacity": "400lbs", "material": "Ripstop Nylon", "weight": "12oz"}'::jsonb, ARRAY['camping', 'hammock', 'outdoor']),
  ('Stainless Steel Water Bottle', 'stainless-steel-water-bottle', 'Insulated 32oz water bottle', 27.99, 34.99, 'SPT-WTB01', 5,
   '{"capacity": "32oz", "material": "Stainless Steel", "insulation": "Double-wall vacuum"}'::jsonb, ARRAY['hydration', 'bottle', 'insulated']),
  ('Foam Roller', 'foam-roller', 'High-density muscle recovery roller', 19.99, NULL, 'SPT-FMR01', 5,
   '{"length": "18 inch", "density": "High", "surface": "Textured"}'::jsonb, ARRAY['recovery', 'fitness', 'roller']);

-- ---------- 4. Inventory (30 — one per product) ----------

INSERT INTO inventory (product_id, quantity_on_hand, quantity_reserved, low_stock_threshold) VALUES
  (1,  50, 3, 10),  (2,  35, 2, 10),  (3,  40, 0, 10),  (4,  25, 1, 10),
  (5,  20, 2, 5),   (6,  15, 0, 5),   (7,  18, 1, 5),
  (8,  100, 5, 20), (9,  80, 3, 20),  (10, 60, 0, 15),  (11, 45, 2, 15),
  (12, 70, 4, 20),  (13, 90, 0, 25),
  (14, 12, 1, 5),   (15, 30, 0, 10),  (16, 8, 2, 5),    (17, 55, 0, 15),
  (18, 40, 0, 15),  (19, 65, 3, 20),
  (20, 200, 10, 50),(21, 150, 5, 40), (22, 120, 0, 30),
  (23, 80, 2, 25),  (24, 95, 0, 25),
  (25, 35, 1, 10),  (26, 60, 0, 15),  (27, 28, 3, 10),  (28, 45, 0, 15),
  (29, 50, 2, 15),  (30, 70, 0, 20);

-- ---------- 5. Addresses (7) ----------

INSERT INTO addresses (user_id, label, line1, line2, city, state, postal_code, country, is_default) VALUES
  ('a1111111-1111-1111-1111-111111111111', 'home',   '123 Main St',    'Apt 4B',  'New York',      'NY', '10001', 'US', true),
  ('a1111111-1111-1111-1111-111111111111', 'work',   '456 Office Blvd', NULL,      'New York',      'NY', '10018', 'US', false),
  ('b2222222-2222-2222-2222-222222222222', 'home',   '789 Oak Ave',     NULL,      'San Francisco', 'CA', '94102', 'US', true),
  ('c3333333-3333-3333-3333-333333333333', 'home',   '321 Pine Rd',    'Suite 10','Austin',        'TX', '73301', 'US', true),
  ('d4444444-4444-4444-4444-444444444444', 'home',   '654 Elm St',      NULL,      'Seattle',       'WA', '98101', 'US', true),
  ('d4444444-4444-4444-4444-444444444444', 'office', '987 Corp Dr',    'Floor 5', 'Seattle',       'WA', '98104', 'US', false),
  ('e5555555-5555-5555-5555-555555555555', 'home',   '246 Birch Ln',    NULL,      'Denver',        'CO', '80201', 'US', true);

-- ---------- 6. Discounts (5) ----------

INSERT INTO discounts (code, description, type, value, min_order_value, max_uses, current_uses, starts_at, expires_at, is_active) VALUES
  ('WELCOME10',  '10% off for new customers',    'percentage',    10.00,  0,    NULL, 12, '2025-01-01'::timestamptz, '2026-12-31'::timestamptz, true),
  ('SAVE20',     '$20 off orders over $100',      'fixed_amount',  20.00, 100.00, 500, 45, '2025-06-01'::timestamptz, '2026-06-30'::timestamptz, true),
  ('FREESHIP',   'Free shipping on all orders',   'free_shipping',  0.00,  50.00, 200, 80, '2025-01-01'::timestamptz, '2026-12-31'::timestamptz, true),
  ('SUMMER25',   '25% off summer sale',           'percentage',    25.00,  0,    100, 98, '2025-06-01'::timestamptz, '2025-09-30'::timestamptz, false),
  ('FLAT15',     '$15 off any order',             'fixed_amount',  15.00,  75.00, 300, 120,'2025-03-01'::timestamptz, '2026-12-31'::timestamptz, true);

-- ---------- 7. Orders (15) ----------
-- We set order_number explicitly to have predictable values in seed data

INSERT INTO orders (order_number, user_id, status, subtotal, discount_total, shipping_total, tax_total, total, shipping_address_id, notes) VALUES
  ('ORD-20260101-000001', 'a1111111-1111-1111-1111-111111111111', 'delivered',  1849.98, 0,     9.99,  148.00, 2007.97, 1, NULL),
  ('ORD-20260115-000001', 'a1111111-1111-1111-1111-111111111111', 'shipped',    109.98,  10.99, 5.99,  8.00,   112.98,  1, 'Please leave at door'),
  ('ORD-20260120-000001', 'b2222222-2222-2222-2222-222222222222', 'delivered',  549.98,  20.00, 0,     42.40,  572.38,  3, NULL),
  ('ORD-20260125-000001', 'b2222222-2222-2222-2222-222222222222', 'processing', 89.99,   0,     7.99,  7.20,   105.18,  3, NULL),
  ('ORD-20260201-000001', 'c3333333-3333-3333-3333-333333333333', 'delivered',  1999.99, 0,     0,     160.00, 2159.99, 4, 'Gift wrap please'),
  ('ORD-20260205-000001', 'c3333333-3333-3333-3333-333333333333', 'confirmed',  74.98,   0,     5.99,  6.00,   86.97,   4, NULL),
  ('ORD-20260210-000001', 'c3333333-3333-3333-3333-333333333333', 'cancelled',  349.99,  0,     9.99,  28.00,  387.98,  4, 'Changed my mind'),
  ('ORD-20260215-000001', 'd4444444-4444-4444-4444-444444444444', 'shipped',    159.98,  15.00, 5.99,  12.08,  162.05,  5, NULL),
  ('ORD-20260218-000001', 'd4444444-4444-4444-4444-444444444444', 'pending',    699.99,  0,     0,     56.00,  755.99,  5, NULL),
  ('ORD-20260220-000001', 'd4444444-4444-4444-4444-444444444444', 'delivered',  44.99,   0,     5.99,  3.60,   54.58,   6, NULL),
  ('ORD-20260222-000001', 'e5555555-5555-5555-5555-555555555555', 'shipped',    279.98,  0,     7.99,  22.40,  310.37,  7, NULL),
  ('ORD-20260225-000001', 'e5555555-5555-5555-5555-555555555555', 'processing', 849.99,  0,     0,     68.00,  917.99,  7, NULL),
  ('ORD-20260226-000001', 'e5555555-5555-5555-5555-555555555555', 'confirmed',  47.98,   0,     5.99,  3.84,   57.81,   7, NULL),
  ('ORD-20260228-000001', 'a1111111-1111-1111-1111-111111111111', 'pending',    199.99,  0,     9.99,  16.00,  225.98,  2, NULL),
  ('ORD-20260301-000001', 'b2222222-2222-2222-2222-222222222222', 'refunded',   129.99,  0,     5.99,  10.40,  146.38,  3, 'Product was defective');

-- ---------- 8. Order Items (19) ----------

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
  -- Order 1: iPhone 15 Pro + Samsung Galaxy S24
  (1, 1,  1, 999.99),
  (1, 2,  1, 849.99),
  -- Order 2: Classic Oxford Shirt + Slim Fit Chinos
  (2, 8,  1, 59.99),
  (2, 9,  1, 49.99),
  -- Order 3: Stand Mixer + Chef's Knife Set
  (3, 14, 1, 349.99),
  (3, 15, 1, 199.99),
  -- Order 4: Merino Wool Sweater
  (4, 10, 1, 89.99),
  -- Order 5: MacBook Pro 14"
  (5, 5,  1, 1999.99),
  -- Order 6: Yoga Mat + Resistance Band Set
  (6, 25, 1, 44.99),
  (6, 26, 1, 29.99),
  -- Order 7: Stand Mixer (cancelled)
  (7, 14, 1, 349.99),
  -- Order 8: Running Sneakers + Leather Belt - discount applied
  (8, 12, 1, 129.99),
  (8, 13, 1, 29.99),
  -- Order 9: Google Pixel 8
  (9, 3,  1, 699.99),
  -- Order 10: Yoga Mat Premium
  (10, 25, 1, 44.99),
  -- Order 11: Chef's Knife Set + Cast Iron Skillet + Scented Candle Set
  (11, 15, 1, 199.99),
  (11, 17, 1, 39.99),
  (11, 18, 1, 29.99),
  -- Order 12: Samsung Galaxy S24
  (12, 2, 1, 849.99);
  -- Orders 13-15 have simpler items covered by the subtotals

-- Note: orders 13, 14, 15 items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
  (13, 28, 1, 34.99),
  (13, 21, 1, 12.99),
  (14, 15, 1, 199.99),
  (15, 12, 1, 129.99);

-- ---------- 9. Reviews (10) ----------

INSERT INTO reviews (product_id, user_id, rating, title, body, is_verified) VALUES
  (1,  'a1111111-1111-1111-1111-111111111111', 5, 'Amazing phone!',          'Best iPhone yet. The titanium frame is gorgeous.',             true),
  (2,  'a1111111-1111-1111-1111-111111111111', 4, 'Great Android phone',     'AI features are actually useful. Battery could be better.',    true),
  (5,  'c3333333-3333-3333-3333-333333333333', 5, 'Best laptop I''ve owned', 'M3 Pro is incredibly fast. Battery lasts all day.',            true),
  (14, 'b2222222-2222-2222-2222-222222222222', 5, 'Professional quality',    'Heavy duty mixer, handles everything from bread to meringue.', true),
  (15, 'b2222222-2222-2222-2222-222222222222', 4, 'Sharp and well balanced', 'Great knife set for the price. Block is beautiful.',           true),
  (8,  'd4444444-4444-4444-4444-444444444444', 3, 'Decent shirt',           'Good quality but runs a bit large. Size down.',                false),
  (25, 'd4444444-4444-4444-4444-444444444444', 4, 'Great yoga mat',         'Good grip and thickness. Perfect for daily practice.',          true),
  (12, 'd4444444-4444-4444-4444-444444444444', 5, 'Super comfortable',      'Best running shoes I''ve ever owned. Light and responsive.',    true),
  (3,  'e5555555-5555-5555-5555-555555555555', 4, 'Camera is incredible',   'Photos are stunning. Software updates keep getting better.',    false),
  (20, 'e5555555-5555-5555-5555-555555555555', 5, 'Page-turner!',           'Couldn''t put it down. Amazing world-building.',                false);

-- ---------- 10. Payments (14 — one per non-cancelled order) ----------

INSERT INTO payments (order_id, method, status, amount, transaction_id) VALUES
  (1,  'credit_card',   'completed', 2007.97, 'txn_abc001'),
  (2,  'credit_card',   'completed', 112.98,  'txn_abc002'),
  (3,  'paypal',        'completed', 572.38,  'txn_abc003'),
  (4,  'debit_card',    'pending',   105.18,  'txn_abc004'),
  (5,  'credit_card',   'completed', 2159.99, 'txn_abc005'),
  (6,  'paypal',        'completed', 86.97,   'txn_abc006'),
  -- Order 7 cancelled, no payment
  (8,  'credit_card',   'completed', 162.05,  'txn_abc008'),
  (9,  'bank_transfer', 'pending',   755.99,  'txn_abc009'),
  (10, 'credit_card',   'completed', 54.58,   'txn_abc010'),
  (11, 'debit_card',    'completed', 310.37,  'txn_abc011'),
  (12, 'credit_card',   'pending',   917.99,  'txn_abc012'),
  (13, 'paypal',        'completed', 57.81,   'txn_abc013'),
  (14, 'credit_card',   'pending',   225.98,  'txn_abc014'),
  (15, 'credit_card',   'refunded',  146.38,  'txn_abc015');

-- ---------- 11. Shipments (8 — for shipped/delivered orders) ----------

INSERT INTO shipments (order_id, carrier, tracking_number, status, shipped_at, delivered_at) VALUES
  (1,  'UPS',   '1Z999AA10123456784', 'delivered',       '2026-01-03'::timestamptz, '2026-01-06'::timestamptz),
  (2,  'USPS',  '9400111899223100001', 'in_transit',     '2026-01-17'::timestamptz, NULL),
  (3,  'FedEx', '794644790132',        'delivered',       '2026-01-22'::timestamptz, '2026-01-25'::timestamptz),
  (5,  'UPS',   '1Z999AA10123456785', 'delivered',       '2026-02-03'::timestamptz, '2026-02-06'::timestamptz),
  (8,  'USPS',  '9400111899223100002', 'in_transit',     '2026-02-17'::timestamptz, NULL),
  (10, 'FedEx', '794644790133',        'delivered',       '2026-02-22'::timestamptz, '2026-02-24'::timestamptz),
  (11, 'UPS',   '1Z999AA10123456786', 'out_for_delivery','2026-02-24'::timestamptz, NULL),
  (15, 'USPS',  '9400111899223100003', 'returned',       '2026-03-01'::timestamptz, NULL);

-- ---------- 12. Order Discounts (5) ----------

INSERT INTO order_discounts (order_id, discount_id, amount) VALUES
  (2,  1, 10.99),  -- WELCOME10 on order 2
  (3,  2, 20.00),  -- SAVE20 on order 3
  (3,  3, 0),      -- FREESHIP on order 3 (free shipping)
  (8,  5, 15.00),  -- FLAT15 on order 8
  (15, 1, 0);      -- WELCOME10 attempted on order 15

-- ---------- 13. Wishlist Items (9) ----------

INSERT INTO wishlist_items (user_id, product_id) VALUES
  ('a1111111-1111-1111-1111-111111111111', 5),   -- Alice wants MacBook
  ('a1111111-1111-1111-1111-111111111111', 16),  -- Alice wants Espresso Machine
  ('b2222222-2222-2222-2222-222222222222', 1),   -- Bob wants iPhone
  ('b2222222-2222-2222-2222-222222222222', 10),  -- Bob wants Merino Sweater
  ('c3333333-3333-3333-3333-333333333333', 27),  -- Carol wants Trail Backpack
  ('c3333333-3333-3333-3333-333333333333', 20),  -- Carol wants Great Adventure book
  ('d4444444-4444-4444-4444-444444444444', 16),  -- Dave wants Espresso Machine
  ('e5555555-5555-5555-5555-555555555555', 5),   -- Eve wants MacBook
  ('e5555555-5555-5555-5555-555555555555', 14);  -- Eve wants Stand Mixer
